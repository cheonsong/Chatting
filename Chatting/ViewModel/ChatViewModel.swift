//
//  ChatViewModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import RxCocoa
import RxSwift

class ChatViewModel: ViewModelType{
    
    struct Input {
        var chatText: Observable<String>
        var tapSendButton: Observable<Void>
        var taplikeButton: Observable<Void>
        var tapDownButton: Observable<Void>
    }
    
    struct Output {
        var addChatList: PublishRelay<ChatModel>
        var likeFlag: BehaviorRelay<Bool>
        var scrollDown: PublishRelay<Void>
        var removeTextInTextView: PublishRelay<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let addChatList = PublishRelay<ChatModel>()
    private let likeFlag = BehaviorRelay(value: false)
    private let scrollDown = PublishRelay<Void>()
    private let removeTextInTextView = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        // TODO: input -> output
        // 데이터 처리 로직 구현하기
        input.taplikeButton
            .scan(false) { (lastState, newValue) in
                !lastState
            }.bind(to: likeFlag)
            .disposed(by: disposeBag)
        
        input.tapSendButton
            .withLatestFrom(input.chatText)
            .filter({!$0.trimmingCharacters(in: .whitespaces).isEmpty})
            .map( {ChatModel(chat: $0)} )
            .bind(to: addChatList)
            .disposed(by: disposeBag)
        
        input.tapSendButton
            .bind(to: removeTextInTextView)
            .disposed(by: disposeBag)
        
        input.tapDownButton
            .bind(to: scrollDown)
            .disposed(by: disposeBag)
        
        return Output(addChatList: addChatList, likeFlag: likeFlag, scrollDown: scrollDown, removeTextInTextView: removeTextInTextView
        )
    }
}
