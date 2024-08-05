//
//  SignupViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SigninViewController: UIViewController {
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력하세요"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let emailStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 형식을 입력하세요"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력하세요"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let nicknameStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "2~10자 사이의 글자를 입력해 주세요"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력하세요"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 8자 이상 입력해주세요"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = SigninViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        
    }
    
    func configure() {
        view.backgroundColor = .white
        
        [emailTextField, emailStatusLabel, nicknameTextField, nicknameStatusLabel, passwordTextField, passwordStatusLabel, loginButton].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        emailStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.left.right.equalTo(emailTextField)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailStatusLabel.snp.bottom).offset(20)
            make.left.right.height.equalTo(emailTextField)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.left.right.equalTo(nicknameTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(20)
            make.left.right.height.equalTo(nicknameTextField)
        }
        
        passwordStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.left.right.equalTo(passwordTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordStatusLabel.snp.bottom).offset(30)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
    }
    
    func bind() {
        let input = SigninViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty.asObservable(),
            nicknameText: nicknameTextField.rx.text.orEmpty.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            tap: loginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.emailValidation
            .bind(to: emailStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nicknameValidation
            .bind(to: nicknameStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .bind(to: passwordStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.loginButtonColor
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.showLoginAlert
            .emit(onNext: { [weak self] in
                self?.showLoginAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func showLoginAlert() {
        let alert = UIAlertController(title: "로그인 완료", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
