//
//  ChatView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ChatView: UIView {
    
    private let viewModel = ChatViewModel()
    var list = [ChatModel]()
    let disposeBag = DisposeBag()
    
    @IBOutlet var chatSuperView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        bindViewModel()
    }
    
    private func initialize() {
        let view = Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    private func bindViewModel() {
        let input = ChatViewModel.Input(
            chatText: textView.rx.text.orEmpty.asObservable(),
            tapSendButton: sendButton.rx.tap.asObservable(),
            taplikeButton: likeButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // TODO: output
        // 뷰에 바인딩 시켜주기
        output.likeFlag
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
    }
    
}
