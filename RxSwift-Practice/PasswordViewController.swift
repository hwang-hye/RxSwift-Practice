//
//  PasswordViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
    
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.textColor = .black
        password.placeholder = "비밀번호를 입력해주새요"
        password.textAlignment = .center
        password.borderStyle = .none
        password.layer.cornerRadius = 10
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.black.cgColor
        return password
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "8자 이상 입력해주세요"
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    func bind() {
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled,
                  nextButton.rx.isHidden,
                  descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemRed
                owner.nextButton.backgroundColor = color
                owner.nextButton.isHidden = !value
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PickerViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.leading.equalTo(passwordTextField.snp.leading)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
