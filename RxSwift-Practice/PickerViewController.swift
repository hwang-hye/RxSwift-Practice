//
//  PickerViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PickerViewController: UIViewController {
    
    let pickerView = UIPickerView()
    let label = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        setPickerView()
    }
    
    func setPickerView() {
        let items = Observable.just([
        "영화",
        "애니메이션",
        "드라마",
        "기타"
        ])
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
    
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
//            .bind(to: label.rx.text)
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
    }
}
