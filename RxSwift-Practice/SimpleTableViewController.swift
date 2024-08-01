//
//  SimpleTableViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimpleTableViewExampleViewController : UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                self?.presentAlert(message: "Tapped `\(value)`")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { [weak self] indexPath in
                self?.presentAlert(message: "Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
