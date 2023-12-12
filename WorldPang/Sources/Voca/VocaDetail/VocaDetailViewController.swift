//
//  VocaDetailViewController.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class VocaDetailViewController: BaseViewController {

    private let viewModel = VocaDetailViewModel()
    private let disposeBag = DisposeBag()
    
    
    init(selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        viewModel.loadData(row: selectedIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

    }
    
    override func setupView() {
        view.addSubview(tableView)
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = learnButton
    }
    
    override func setupLayout() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
    }
    
    override func bindRX() {
        
        viewModel.vocaDetailRelay
            .bind(to: tableView.rx.items(cellIdentifier: VocaDetailCell.reusableIdentifier, cellType: VocaDetailCell.self)) { row,model,cell  in
                cell.isUserInteractionEnabled = false
                
                cell.titleLabel.text = model.word
                cell.meanLabel.text = model.meaning
                
                cell.meanButton.rx.tap
                    .subscribe(onNext: { _ in
                        cell.meanButton.setTitle(model.meaning, for: .normal)
                    })
                    .disposed(by: self.disposeBag)
                
                
                cell.speakerEnButton.rx
                    .tap
                    .subscribe(onNext: { _ in
                        TTSManager.shared.play(cell.titleLabel.text ?? "")
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        learnButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.startLearning()
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    func startLearning() {
        navigationItem.rightBarButtonItem?.title = "종료하기"
    }
    
    //MARK: UI
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .mainWhite
        view.register(VocaDetailCell.self, forCellReuseIdentifier:  VocaDetailCell.reusableIdentifier)
        return view
    }() 
    
    let learnButton = UIBarButtonItem(title: "학습하기", style: .plain, target: self, action: nil)
    


}

extension VocaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .destructive, title: "아는단어에요"){ _,_,_ in
            print("Eddit")
        }
        edit.backgroundColor = .mainBlue
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .destructive, title: "모르는단어에요"){ _,_,_ in
            print("Eddit")
        }
        edit.backgroundColor = .blue
        
    
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit])
        return swipeConfiguration
    }
}

