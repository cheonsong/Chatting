//
//  JoinViewModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/19.
//

import Foundation
import RxSwift
import RxCocoa

class JoinViewModel: ViewModelType {
    
    struct Input {
        var backButtonClicked: Observable<Void>
        var manButtonClicked: Observable<Void>
        var womanButtonClicked: Observable<Void>
        var yearButtonClicked: Observable<Void>
        var monthButtonClicked: Observable<Void>
        var dayButtonClicked: Observable<Void>
        var introduceText: Observable<String>
        var joinButtonClicked: Observable<Void>
        
    }
    
    struct Output {
        var deleteView: PublishRelay<Void>
    }
    
    let disposeBag = DisposeBag()
    let deleteView = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.backButtonClicked
            .bind(to: deleteView)
            .disposed(by: disposeBag)
        
        return Output(deleteView: deleteView)
    }
    
}
