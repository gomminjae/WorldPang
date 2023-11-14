//
//  OCRResultViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources


class OCRResultViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = OCRViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(translatedWordsTableView)
        
    }
    
    override func setupLayout() {
        
    }
    
    override func bindRX() {
        
    }
    
//    private func configureTableView() {
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Voca>>(
//            configureCell: { (_, tableView, indexPath, item) in
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WordCell else { return UITableViewCell() }
//                cell.wordLabel.text = item.word
//                cell.meanLabel.text = item.mean
//                return cell
//            }
//    }
    
    //MARK: UI
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recognized Text"
        
        return label
    }()
    
    let originalTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }() 
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    let translatedWordsTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .blue
        view.register(WordCell.self, forCellReuseIdentifier: WordCell.reusableIdentifier)
        return view
    }()
}
