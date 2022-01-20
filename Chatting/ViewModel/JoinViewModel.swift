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
        var imagePickButtonClicked: Observable<Void>
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
        var checkManButton: PublishRelay<Void>
        var checkWomanButton: PublishRelay<Void>
        var imagePick: PublishRelay<Void>
        var yearPick: PublishRelay<Void>
        var monthPick: PublishRelay<Void>
        var dayPick: PublishRelay<Void>
        var textCount: PublishRelay<String>
        var userInfo: PublishRelay<Void>
    }
    
    let disposeBag = DisposeBag()
    
    let deleteView = PublishRelay<Void>()
    let checkManButton = PublishRelay<Void>()
    let checkWomanButton = PublishRelay<Void>()
    let imagePick = PublishRelay<Void>()
    let yearPick = PublishRelay<Void>()
    let monthPick = PublishRelay<Void>()
    let dayPick = PublishRelay<Void>()
    let textCount = PublishRelay<String>()
    let userInfo = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.backButtonClicked
            .bind(to: deleteView)
            .disposed(by: disposeBag)
        
        input.manButtonClicked
            .bind(to: checkManButton)
            .disposed(by: disposeBag)
        
        input.womanButtonClicked
            .bind(to: checkWomanButton)
            .disposed(by: disposeBag)

        input.imagePickButtonClicked
            .bind(to: imagePick)
            .disposed(by: disposeBag)

        input.yearButtonClicked
            .bind(to: yearPick)
            .disposed(by: disposeBag)
        
        input.monthButtonClicked
            .bind(to: monthPick)
            .disposed(by: disposeBag)
        
        input.dayButtonClicked
            .bind(to: dayPick)
            .disposed(by: disposeBag)
        
        input.introduceText
            .map({"(\($0.count)/200)"})
            .bind(to: textCount)
            .disposed(by: disposeBag)
        
        input.joinButtonClicked
            .bind(to: userInfo)
            .disposed(by: disposeBag)
        
        return Output(deleteView: deleteView, checkManButton: checkManButton, checkWomanButton: checkWomanButton, imagePick: imagePick, yearPick: yearPick, monthPick: monthPick, dayPick: dayPick, textCount: textCount, userInfo: userInfo
        )
    }
    
}
