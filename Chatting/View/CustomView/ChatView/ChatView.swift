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
import SocketIO
import SwiftyJSON

class ChatView: UIView {
    
    // MARK: Property
    let colorManager = CustomColor()
    let placeholder = "대화를 입력하세요"
    var view: UIView?
    private let viewModel = ChatViewModel()
    var list = [ChatModel]() {
        didSet {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.list.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    var memInfo = MemberInfo()
    
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
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: init & deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        bindViewModel()
        print("===============ChatView init===============")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        bindViewModel()
        print("===============ChatView init===============")
    }
    
    // MARK: Function
    private func initialize() {
        self.view = Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
        
        setTextView()
        
        setGestureRecognizer()
        
        setTableView()
        
        setKeyboardNoti()
        
        setBackground()
        
        setSocketHandler()
        
    }
    
    private func bindViewModel() {
        
        let input = ChatViewModel.Input(
            chatText: textView.rx.text.orEmpty.asObservable(),
            tapSendButton: sendButton.rx.tap.asObservable(),
            taplikeButton: likeButton.rx.tap.asObservable(),
            tapDownButton: downButton.rx.tap.asObservable(),
            tapCancelButton: cancelButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // TODO: output
        // 뷰에 바인딩 시켜주기
        
        // likeFlag
        // TRUE: 좋아요 버튼 이미지 활성화
        // FALSE: 좋아요 버튼 이미지 비활성화
        output.likeFlag
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // addChatList
        // ChatModel을 ChatList에 추가
        output.addChatList
            .subscribe(onNext: {
                ChatSocketManager.instance.sendChatMessage($0.chat!)
            })
            .disposed(by: disposeBag)
        
        // scrollDown
        // 아래로버튼 클릭 시 가장 최근에 대화로 이동
        output.scrollDown
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.scrollToRow(at: IndexPath(row: self.list.count - 1, section: 0), at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
        
        // removeTextInTextView
        // 사연을 보내면 입력창의 텍스트 초기화
        // 가장 최신 대화로 이동
        output.removeTextInTextView
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.textView.text = ""
            })
            .disposed(by: disposeBag)
        
        // deleteView
        // 채팅방 나가기
        output.deleteView
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.removeFromSuperview()
                ChatSocketManager.instance.roomOut()
                self.list.removeAll()
            })
            .disposed(by: disposeBag)
        
        output.likeAnimation
            .subscribe(onNext: { [weak self] in
                //guard let self = self else { return }
                ChatSocketManager.instance.sendLike()
            })
            .disposed(by: disposeBag)
        
    }
    
    func setSocketHandler() {
        ChatSocketManager.instance.serviceProvider?.socket?.on("message", callback: { data, ack in
            print(data)
            guard let dataInfo = data.first else { return }
            let json = JSON(dataInfo)
            switch (json["cmd"].stringValue) {
            case "rcvSystemMsg":
                let chat = ChatModel(chat: json["msg"].stringValue)
                chat.type = .system
                self.list.append(chat)
                
            case "rcvChatMsg":
                let chat = ChatModel(chat: json["msg"].stringValue)
                chat.type = .user
                chat.nickname = json["from"]["chat_name"].stringValue
                chat.imageLink = json["from"]["mem_photo"].stringValue
                self.list.append(chat)
                
                
            default:
                print("default")
            }
        })
    }
    
    private func setBackground() {
        let image = UIImage(named: "background")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = self.bounds
        insertSubview(imageView, at: 0)
    }
    
    
    private func setTextView() {
        textView.backgroundColor = .white
        textSuperView.layer.cornerRadius = 18
        textView.text = placeholder
    }
}
