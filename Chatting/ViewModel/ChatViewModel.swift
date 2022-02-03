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
        var tapCancelButton: Observable<Void>
    }
    
    struct Output {
        var addChatList: PublishRelay<ChatModel>
        var likeFlag: BehaviorRelay<Bool>
        var scrollDown: PublishRelay<Void>
        var removeTextInTextView: PublishRelay<Void>
        var deleteView: PublishRelay<Void>
        var likeAnimation: PublishRelay<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let addChatList = PublishRelay<ChatModel>()
    private let likeFlag = BehaviorRelay(value: false)
    private let scrollDown = PublishRelay<Void>()
    private let removeTextInTextView = PublishRelay<Void>()
    private let deleteView = PublishRelay<Void>()
    private let likeAnimation = PublishRelay<Void>()
    
    
    /// Input 값을 입력 받아 처리 후 Output값을 출력
    /// - Parameter input: Input
    /// - Returns: Output
    func transform(input: Input) -> Output {
        // 데이터 처리 로직 구현하기
        // 좋아요 버튼 이벤트 처리
        // tapLikeButton -> likeFlag(Bool)
        input.taplikeButton
            .scan(false) { (lastState, newValue) in
                !lastState
            }.bind(to: likeFlag)
            .disposed(by: disposeBag)
        
        // 채팅 보내기 버튼
        // tapSendButton -> ChatModel( chatText )
        input.tapSendButton
            .withLatestFrom(input.chatText)
            .map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
            .filter({!$0.isEmpty})
            .map( {ChatModel(chat: $0)} )
            .bind(to: addChatList)
            .disposed(by: disposeBag)
        
        // 채팅 보내기 버튼
        // tapSendButton -> RemoveTextInTextView(Void)
        input.tapSendButton
            .bind(to: removeTextInTextView)
            .disposed(by: disposeBag)
        
        // 아래로 이동 버튼
        // tapDownButton -> scrollDown(Void)
        input.tapDownButton
            .bind(to: scrollDown)
            .disposed(by: disposeBag)
        
        // 채팅방 나가기 버튼
        // tapCancelButton -> deleteView(Void)
        input.tapCancelButton
            .bind(to: deleteView)
            .disposed(by: disposeBag)
        
        input.taplikeButton
            .bind(to: likeAnimation)
            .disposed(by: disposeBag)
        
        return Output(addChatList: addChatList, likeFlag: likeFlag, scrollDown: scrollDown, removeTextInTextView: removeTextInTextView, deleteView: deleteView, likeAnimation: likeAnimation
        )
    }
}
