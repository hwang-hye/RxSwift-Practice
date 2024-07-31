//
//  SimpleValidation.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {
    
    var username: UITextField!
    var usernameValid: UILabel!

    var password: UITextField!
    var passwordValid: UILabel!

    var doSomething: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        username = UITextField()
        usernameValid = UILabel()
        password = UITextField()
        passwordValid = UILabel()
        doSomething = UIButton(type: .system)
        
        username.borderStyle = .roundedRect
        password.borderStyle = .roundedRect
        doSomething.setTitle("Do Something", for: .normal)
        doSomething.backgroundColor = .blue
        doSomething.tintColor = .white
        
        view.addSubview(username)
        view.addSubview(usernameValid)
        view.addSubview(password)
        view.addSubview(passwordValid)
        view.addSubview(doSomething)
        
        username.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        usernameValid.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        password.snp.makeConstraints { make in
            make.top.equalTo(usernameValid.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        passwordValid.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        doSomething.snp.makeConstraints { make in
            make.top.equalTo(passwordValid.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        usernameValid.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValid.text = "Password has to be at least \(minimalPasswordLength) characters"
    }
    
    private func bindUI() {
        let usernameValidObservable = username.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValidObservable = password.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValidObservable, passwordValidObservable) { $0 && $1 }
            .share(replay: 1)
        
        usernameValidObservable
            .bind(to: password.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValidObservable
            .bind(to: usernameValid.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValidObservable
            .bind(to: passwordValid.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomething.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomething.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
