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
        let emailValid = emailTextField.rx.text.orEmpty
            .map { $0.contains("@") }
            .share(replay: 1)
        
        emailValid
            .map { $0 ? "사용할 수 있는 이메일 입니다" : "이메일 형식을 입력하세요" }
            .bind(to: emailStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        emailValid
            .map { $0 ? UIColor.black : UIColor.systemRed }
            .bind(to: emailStatusLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        let nicknameValid = nicknameTextField.rx.text.orEmpty
            .map { text -> (Bool, String) in
                if text.count < 2 || text.count > 10 {
                    return (false, "2~10자 사이의 글자를 입력해주세요")
                }
                if text.rangeOfCharacter(from: .decimalDigits) != nil {
                    return (false, "숫자를 포함할 수 없습니다")
                }
                if text.rangeOfCharacter(from: .punctuationCharacters) != nil {
                    return (false, "특수문자는 사용할 수 없습니다")
                }
                return (true, "사용할 수 있는 닉네임입니다")
            }
            .share(replay: 1)
        
        nicknameValid
            .map { $0.1 }
            .bind(to: nicknameStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        nicknameValid
            .map { $0.0 ? UIColor.black : UIColor.systemRed }
            .bind(to: nicknameStatusLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
        
        passwordValid
            .map { $0 ? "사용 가능한 비밀번호입니다" : "비밀번호는 8자 이상 입력해주세요" }
            .bind(to: passwordStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordValid
            .map { $0 ? UIColor.black : UIColor.systemRed }
            .bind(to: passwordStatusLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, nicknameValid, passwordValid)
            .map { $0 && $1.0 && $2 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, nicknameValid, passwordValid)
            .map { $0 && $1.0 && $2 ? UIColor.systemBlue : UIColor.gray }
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind { [weak self] in
                let alert = UIAlertController(title: "로그인 완료", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
