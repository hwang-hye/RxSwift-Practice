//
//  UIViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UISampleViewController: UIViewController {
    
    let sampleSwitch = UISwitch()
    let signName = UITextField()
    let signEmail = UITextField()
    let signButton = UIButton()
    let sampleLabel = UILabel()
    let diposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        signName.backgroundColor = .lightGray
        signEmail.backgroundColor = .lightGray
        signButton.backgroundColor = .blue
        sampleLabel.backgroundColor = .darkGray
        
        view.addSubview(sampleSwitch)
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(signButton)
        view.addSubview(sampleLabel)
        
        sampleSwitch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            
        }
        signName.snp.makeConstraints { make in
            make.top.equalTo(sampleSwitch.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        sampleLabel.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        setSwitch()
        setSign()
    }
    
    func setSwitch() {
        Observable.of(false) // just? of?
            .bind(to: sampleSwitch.rx.isOn)
            .disposed(by: diposeBag)
    }
    
    func setSign() {
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, email은 \(value2)입니다"
        }
        .bind(to: sampleLabel.rx.text)
        .disposed(by: diposeBag)
        
        signName.rx.text.orEmpty // String
            .map { $0.count < 4 } //Int
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: diposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signButton.rx.isHidden)
            .disposed(by: diposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: diposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "알림", message: "버튼이 눌렸습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
