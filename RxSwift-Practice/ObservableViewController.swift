//
//  ObservableViewController.swift
//  RxSwift-Practice
//
//  Created by hwanghye on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ObservableViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //sampleJust()
        // sampleOf()
        sampleFrom()
        
    }
    
    func sampleJust() {
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        Observable.just(itemA)
            .subscribe { value in
                print("just- \(value)")
            } onError: { error in
                print("just- \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func sampleOf() {
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemB = [2.3, 2.0, 1.3]
        
        Observable.of(itemA, itemB)
            .subscribe { value in
                print("of- \(value)")
            } onError: { error in
                print("of- \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func sampleFrom() {
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        Observable.from(itemA)
            .subscribe { value in
                print("from- \(value)")
            } onError: { error in
                print("from- \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
}

