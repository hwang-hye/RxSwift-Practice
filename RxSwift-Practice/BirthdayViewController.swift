//
//  BirthdayViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthdayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorSubject(value: 8)
    let day = BehaviorSubject(value: 1)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        
    }
    
    func bind() {
        birthdayPicker.rx.date // date가 달라졌을 때
            .bind(with: self) { owner, date in
                print("날짜 바뀜: \(date)")
                
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                
                owner.year.accept(component.year!) // 값만 전달
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
                
                owner.updateUI(for: date)
            }
            .disposed(by: disposeBag)

        year
            .map { "\($0)년"}
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .bind(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            }
            .disposed(by: disposeBag)
        
        day
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.dayLabel.text = "\(value)일"
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showCompletionAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func updateUI(for date: Date) {
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: date, to: now)
            let age = ageComponents.year!
            
            if age >= 17 {
                infoLabel.text = "가입 가능한 나이입니다"
                infoLabel.textColor = .black
                nextButton.backgroundColor = .systemBlue
                nextButton.isEnabled = true
            } else {
                infoLabel.text = "만 17세 이상만 가입 가능합니다."
                infoLabel.textColor = .systemRed
                nextButton.backgroundColor = .gray
                nextButton.isEnabled = false
            }
        }
    
    func showCompletionAlert() {
            let alert = UIAlertController(title: "완료", message: "가입이 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    func configure() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthdayPicker)
        view.addSubview(nextButton)
        
        view.backgroundColor = .white
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthdayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthdayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
