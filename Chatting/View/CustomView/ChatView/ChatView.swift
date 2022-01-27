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

class ChatView: UIView{
    
    // MARK: Property
    let colorManager = CustomColor.instance
    let placeholder = "대화를 입력하세요"
    var view: UIView?
    private let viewModel = ChatViewModel()
    var list = [ChatModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var memInfo = MemberInfo()
    var apiManager = JoinApiManager(service: APIServiceProvider())
    
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
        self.initialize()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.initialize()
        self.bindViewModel()
        
        
    }
    
    override func draw(_ rect: CGRect) {
        setTableViewGradient()
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
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
            .subscribe(onNext: {
                ChatSocketManager.instance.roomOut { [weak self] ack in
                    let json = JSON(ack.first!)
                    if(json["success"].stringValue == "y") {
                        self?.list.removeAll()
                        self?.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.likeAnimation
            .subscribe(onNext: {
                ChatSocketManager.instance.sendLike()
            })
            .disposed(by: disposeBag)
        
    }
    
    // "message" 핸들로러 온 이벤트 처리
    func setSocketHandler() {
        ChatSocketManager.instance.serviceProvider?.socket?.on("message", callback: { data, ack in
            print(data)
            guard let dataInfo = data.first else { return }
            let json = JSON(dataInfo)
            switch (json["cmd"].stringValue) {
        
            // 시스템 메세지
            case "rcvSystemMsg":
                let chat = ChatModel(chat: json["msg"].stringValue)
                chat.type = .system
                self.list.append(chat)
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            // 채팅 메세지
            case "rcvChatMsg":
                let chat = ChatModel(chat: json["msg"].stringValue)
                chat.type = .user
                chat.nickname = json["from"]["chat_name"].stringValue
                chat.imageLink = json["from"]["mem_photo"].stringValue
                chat.email = json["from"]["mem_id"].stringValue
                self.list.append(chat)
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
            // 토스트 메세지
            case "rcvToastMsg":
                print("토스트 메세지 : " + json["msg"].stringValue)
            
            // 알림 메세지
            case "rcvAlertMsg":
                print("알림 : " + json["msg"].stringValue)
                
            // 좋아요 애니메이션 메세지
            case "rcvPlayLikeAni":
                print("좋아요 에니메이션 하세요")
                
            default:
                print("default")
            }
        })
    }
    
    // 배경을 이미지뷰로 교체
    private func setBackground() {
        let image = UIImage(named: "background")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = self.bounds
        insertSubview(imageView, at: 0)
    }
    
    // 텍스트 뷰 초기화
    private func setTextView() {
        textView.backgroundColor = .white
        textSuperView.layer.cornerRadius = 18
        textView.text = placeholder
    }
}
