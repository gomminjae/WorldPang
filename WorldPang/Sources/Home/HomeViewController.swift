//
//  HomeViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources


class HomeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    let pointManager = PointManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePoints()
    }
    
    override func setupView() {
       // view.setGradient(color1: .mainYellow, color2: .subYellow)
        view.backgroundColor = .mainBlue
        view.addSubview(titleLabel)
        
        view.addSubview(baseView)
        baseView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        baseView.addSubview(userCurrentStateView)
        
        view.addSubview(pagerCollectionView)
        
        userCurrentStateView.addSubview(middleSideBar)
        userCurrentStateView.addSubview(todayVocaState)
        userCurrentStateView.addSubview(vocaNumberLabel)
        userCurrentStateView.addSubview(pointLabel)
        userCurrentStateView.addSubview(pointTitleLabel)
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userProfileImageButton)
        
        
    }
    
    override func setupLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(view).inset(30)
        }
        
        
        baseView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        userCurrentStateView.snp.makeConstraints {
            $0.leading.equalTo(baseView).inset(20)
            $0.trailing.equalTo(baseView).inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.height.equalTo(90)
        }
        
        pagerCollectionView.snp.makeConstraints {
            $0.top.equalTo(userCurrentStateView.snp.bottom).offset(10)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        middleSideBar.snp.makeConstraints {
            $0.top.equalTo(userCurrentStateView.snp.top).inset(20)
            $0.bottom.equalTo(userCurrentStateView.snp.bottom).inset(20)
            $0.width.equalTo(2)
            $0.centerX.equalTo(userCurrentStateView)
        }
        
        
        todayVocaState.snp.makeConstraints {
            $0.top.equalTo(userCurrentStateView).inset(20)
            
            $0.leading.equalTo(middleSideBar).offset(25)
        }
        
        vocaNumberLabel.snp.makeConstraints {
            $0.top.equalTo(todayVocaState).offset(30)
            $0.leading.trailing.equalTo(todayVocaState)
            
        }
        
        pointTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(userCurrentStateView).inset(70)
            $0.top.equalTo(userCurrentStateView).inset(20)
            //$0.trailing.equalTo(middleSideBar).offset(25)
        }
        pointLabel.snp.makeConstraints {
            $0.top.equalTo(pointTitleLabel).offset(30)
            $0.leading.trailing.equalTo(pointTitleLabel)
        }
    }
    
    override func bindRX() {
    
        
        viewModel.stageObservable
            .bind(to: pagerCollectionView.rx.items(cellIdentifier: PagerCell.reusableIdentifier, cellType: PagerCell.self)) { index, stage, cell in
                
                switch index {
                case 0:
                    cell.titleLabel.text = stage.content
                    cell.imageView.image = UIImage(named: "ar")
                case 1:
                    cell.titleLabel.text = stage.content
                    cell.imageView.image = UIImage(named: "planet")
                default:
                    cell.titleLabel.text = stage.content
                    cell.imageView.image = UIImage(named: "fruits")
                }
                cell.layer.borderColor = UIColor.mainBlue.cgColor
                cell.layer.borderWidth = 5
               
                //cell.backgroundColor = UIColor.random()
            }
            .disposed(by: disposeBag)
        
        
        
        pagerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
       
        
        pagerCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                let arViewModel = ARViewModel()
                switch indexPath.item {
                case 0:
                    arViewModel.arCategory = .normal
                    // ARViewController로 화면 전환
                    if let arViewController = storyboard?.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
                        arViewController.modalPresentationStyle = .fullScreen
                        arViewController.selectedCategory = .normal
                        present(arViewController,animated: true)
                    }
                case 1:
                    arViewModel.arCategory = .space
                    if let spaceViewController = storyboard?.instantiateViewController(withIdentifier: "SpaceVC") as? SpaceViewController {
                        spaceViewController.modalPresentationStyle = .fullScreen
                        present(spaceViewController,animated: true)
                    }
                default:
                    arViewModel.arCategory = .fruits
                    if let arViewController = storyboard?.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
                        arViewController.modalPresentationStyle = .fullScreen
                        arViewController.selectedCategory = .fruits
                        present(arViewController,animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.userInfo
            .subscribe(onNext: { [weak self] user in
                self?.titleLabel.text = user?.nickname
                
                if let imageURL = user?.profileImageURL {
                    self?.viewModel.loadProfileImage(urlString: imageURL) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.userProfileImageButton.setImage(image, for: .normal)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.userInfo
            .subscribe(onNext: { [weak self] user in
                if let user = user {
                    self?.updateUserData(with: user)
                    self?.updateUserProfileImage(with: user.profileImageURL!)
                    
                } else {
                    print("유저정보가 없음")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pointsSubject
            .map { String($0)}
            .bind(to: pointLabel.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
    private func updateUserData(with user: User) {
        titleLabel.text = "Welcome! \(user.nickname)"
    }
    
    private func updateUserProfileImage(with url: URL) {
        viewModel.loadProfileImage(urlString: url) { image in
            DispatchQueue.main.async {

                self.userProfileImageButton.setImage(image, for: .normal)
            }
        }
    }
    private func updatePoints() {
        print("AR dismissed")
        DispatchQueue.main.async {
            let points = self.pointManager.getPoints()
            self.pointLabel.text = String(points)
            self.vocaNumberLabel.text = String(points/10)
        }
    }
    
    
    //MARK: UI
    
    lazy var pagerCollectionView: UICollectionView = {
        let layout = CardPagingLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(PagerCell.self, forCellWithReuseIdentifier: PagerCell.reusableIdentifier)
        return view
    }()
    
    
    lazy var middleSideBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var userCurrentStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        view.layer.borderWidth = 0.1
        view.layer.cornerRadius = 20
        view.setShadow()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var todayVocaState: UILabel = {
        let label = UILabel()
        label.text = "오늘 공부한 단어 수"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var vocaNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    lazy var pointTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Point"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var pointLabel: UILabel = {
        let label = UILabel()
        label.text = "0/150"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    lazy var userProfileImageButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    

    

}
extension HomeViewController: UIScrollViewDelegate {
    
}
