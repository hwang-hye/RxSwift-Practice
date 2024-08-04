//
//  PhoneViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
    
    let phoneNumberTextField: UITextField = {
        let number = UITextField()
        number.textColor = .black
        number.text = "010"
        number.textAlignment = .center
        number.borderStyle = .none
        number.layer.cornerRadius = 10
        number.layer.borderWidth = 1
        number.layer.borderColor = UIColor.black.cgColor
        return number
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        
    }
    
    func bind() {
        let validation = phoneNumberTextField.rx.text.orEmpty
            .map { text -> Bool in
                let phoneNumber = text.filter { $0.isNumber }
                return phoneNumber.count > 10 && phoneNumber == text
            }
                
                
                validation
                    .bind(with: self) { owner, value in
                        let color: UIColor = .systemBlue
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
            view.addSubview(phoneNumberTextField)
            view.addSubview(nextButton)
            
            phoneNumberTextField.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            }
            
            nextButton.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.top.equalTo(phoneNumberTextField.snp.bottom).offset(30)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            }
        }
    }
