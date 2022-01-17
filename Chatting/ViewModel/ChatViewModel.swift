//
//  ChatViewModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import RxCocoa
import RxSwift

class ChatViewModel: ViewModel{
    
    struct Input {
        var chatText: Observable<String>
        var tapSendButton: Observable<Void>
        var taplikeButton: Observable<Void>
    }
    
    struct Output {
        //var addChat: Observable<String>
        var likeFlag: BehaviorRelay<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let addChat = BehaviorRelay(value: "")
    private var likeFlag = BehaviorRelay(value: false)
    
    func transform(input: Input) -> Output {
        // TODO: input -> output
        // 데이터 처리 로직 구현하기
        input.taplikeButton
            .scan(false) { (lastState, newValue) in
                !lastState
            }.bind(to: likeFlag)
            .disposed(by: disposeBag)
        
        return Output(likeFlag: likeFlag)
    }
}
