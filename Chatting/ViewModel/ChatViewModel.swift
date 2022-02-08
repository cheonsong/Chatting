//
//  ChatViewModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import RxCocoa
import RxSwift

class ChatViewModel: ViewModelType {
    
    let socketManager = ChatSocketManager.instance
    
    struct Input {
        var chatText: Observable<String>
        var tapSendButton: Observable<Void>
        var taplikeButton: Observable<Void>
        var tapDownButton: Observable<Void>
        var tapCancelButton: Observable<Void>
    }
    
    struct Output {
        var likeFlag: BehaviorRelay<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let likeFlag = BehaviorRelay(value: false)
    
    init() {
        print("ChatViewModel init")
    }
    
    deinit {
        print("ChatViewModel deinit")
        disposeBag = DisposeBag()
    }
    
    /// Input 값을 입력 받아 처리 후 Output값을 출력
    /// - Parameter : Input
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
            .subscribe(onNext:{ [weak self] chat in
                self?.socketManager.sendChatMessage(chat)
            })
            .disposed(by: disposeBag)
        
        // 채팅방 나가기 버튼
        // tapCancelButton -> deleteView(Void)
        
        input.tapCancelButton
            .subscribe(onNext: { [weak self] in
                self?.socketManager.serviceProvider?.disconnection()
            })
            .disposed(by: disposeBag)
        
        // 좋아요 버튼
        // taplikeButton -> likeAnimatioin
        input.taplikeButton
            .subscribe(onNext: { [weak self] in
                self?.socketManager.sendLike()
            })
            .disposed(by: disposeBag)
        
        return Output(likeFlag: likeFlag)
    }
}
