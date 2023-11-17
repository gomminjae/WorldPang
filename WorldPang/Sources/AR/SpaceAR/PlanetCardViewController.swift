//
//  PlanetCardViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PlanetCardViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let planetViewModel = PlanetListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(tableView)
    }
    
    override func setupLayout() {
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view)
        }
    }
    
    override func bindRX() {
        
        planetViewModel.planetObservable
            .bind(to: tableView.rx.items(cellIdentifier: PlanetListCell.reusableIdentifier, cellType: PlanetListCell.self)) { row,planet,cell in
                cell.planetImageView.image = planet.planetImage
                cell.titleLabel.text = planet.title
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    let tableView = UITableView()
    

   
}
