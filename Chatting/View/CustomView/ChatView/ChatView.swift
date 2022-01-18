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
    
    // MARK: Property
    let colorManager = CustomColor()
    let placeholder = "대화를 입력하세요"
    var view: UIView?
    private let viewModel = ChatViewModel()
    var list = [ChatModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: IBOutlet
    @IBOutlet weak var chatSuperView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var textSuperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: init & deinit
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
    
    deinit {
        removeKeyboardNoti()
    }
    
    // MARK: Function
    private func initialize() {
        self.view = Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
        
        textView.backgroundColor = .white
        textSuperView.layer.cornerRadius = 18
        textView.text = placeholder
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.tableView?.addGestureRecognizer(tapGesture)
        
        setTableView()
        
        setKeyboardNoti()
    }
    
    private func bindViewModel() {
        
        let input = ChatViewModel.Input(
            chatText: textView.rx.text.orEmpty.asObservable(),
            tapSendButton: sendButton.rx.tap.asObservable(),
            taplikeButton: likeButton.rx.tap.asObservable(),
            tapDownButton: downButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // TODO: output
        // 뷰에 바인딩 시켜주기
        output.likeFlag
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.addChatList
            .subscribe(onNext: {
                self.list.append($0)
            })
            .disposed(by: disposeBag)
        
        output.scrollDown
            .subscribe(onNext: {
                self.tableView.scrollToRow(at: IndexPath(row: self.list.count-1, section: 0), at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.removeTextInTextView
            .subscribe(onNext: {
                self.textView.text = ""
            })
            .disposed(by: disposeBag)
        
    }
    
}
