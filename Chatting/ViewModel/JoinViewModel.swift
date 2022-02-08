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
        let introduceText: Observable<String>
    }
    
    struct Output {
        let textCount: PublishRelay<String>
    }
    
    let disposeBag = DisposeBag()
    
    let textCount = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.introduceText
            .map({"(\($0.count)/200)"})
            .bind(to: textCount)
            .disposed(by: disposeBag)
        

        return Output(textCount: textCount)
    }
    
}
