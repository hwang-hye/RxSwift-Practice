//
//  AddingNumberViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddingNumbersViewController: UIViewController {
    var number1: UITextField!
    var number2: UITextField!
    var number3: UITextField!
    var result: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // Combine Latest Observables
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty
        ) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        number1 = UITextField()
        number2 = UITextField()
        number3 = UITextField()
        result = UILabel()
        
        number1.borderStyle = .roundedRect
        number2.borderStyle = .roundedRect
        number3.borderStyle = .roundedRect
        
        number1.placeholder = "Enter number 1"
        number2.placeholder = "Enter number 2"
        number3.placeholder = "Enter number 3"
        
        result.textAlignment = .center
        result.font = UIFont.systemFont(ofSize: 24)
        
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(result)
        
        number1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
