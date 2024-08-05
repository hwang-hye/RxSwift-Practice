//
//  SigninViewModel.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class SigninViewModel {
    
    struct Input {
        let emailText: Observable<String> //emailTextField.rx.text
        let nicknameText: Observable<String> //nicknameTextField.rx.text
        let passwordText: Observable<String> //passwordTextField.rx.text
        let tap: ControlEvent<Void> //loginButton.rx.tap
    }
    
    struct Output {
        let emailValidation: Observable<String>
        let nicknameValidation: Observable<String>
        let passwordValidation: Observable<String>
        let isLoginEnabled: Observable<Bool>
        let loginButtonColor: Observable<UIColor>
        let showLoginAlert: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        let emailValidation = input.emailText
            .map { $0.contains("@") ? "사용할 수 있는 이메일 입니다" : "이메일 형식을 입력하세요" }
        
        let nicknameValidation = input.nicknameText
            .map { text -> String in
                if text.count < 2 || text.count > 10 {
                    return "2~10자 사이의 글자를 입력해주세요"
                }
                if text.rangeOfCharacter(from: .decimalDigits) != nil {
                    return "숫자를 포함할 수 없습니다"
                }
                if text.rangeOfCharacter(from: .punctuationCharacters) != nil {
                    return "특수문자는 사용할 수 없습니다"
                }
                return "사용할 수 있는 닉네임입니다"
            }
        
        let passwordValidation = input.passwordText
            .map { $0.count >= 8 ? "사용 가능한 비밀번호입니다" : "비밀번호는 8자 이상 입력해주세요" }
        
        let isLoginEnabled = Observable.combineLatest(input.emailText, input.nicknameText, input.passwordText) { email, nickname, password in
            return email.contains("@") &&
                   nickname.count >= 2 && nickname.count <= 10 &&
                   nickname.rangeOfCharacter(from: .decimalDigits) == nil &&
                   nickname.rangeOfCharacter(from: .punctuationCharacters) == nil &&
                   password.count >= 8
        }
        
        let loginButtonColor = isLoginEnabled.map { $0 ? UIColor.systemBlue : UIColor.gray }
        
        let showLoginAlert = input.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            emailValidation: emailValidation,
            nicknameValidation: nicknameValidation,
            passwordValidation: passwordValidation,
            isLoginEnabled: isLoginEnabled,
            loginButtonColor: loginButtonColor,
            showLoginAlert: showLoginAlert
        )
    }
}
