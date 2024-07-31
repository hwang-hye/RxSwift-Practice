//
//  TableViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TableViewController: UIViewController {
    
    let tableView = UITableView()
    let textLabel = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textLabel.backgroundColor = .lightGray
        
        view.addSubview(tableView)
        view.addSubview(textLabel)
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        setTableView()
    
    }
    
    func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
        "First Item",
        "Second Item",
        "Third Item"
        ])
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map { data in
            "\(data)를 클릭했습니다"
            }
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

