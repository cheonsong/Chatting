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
import Lottie
import SDWebImageWebPCoder

class ChatView: UIView{
    
    // MARK: Variables
    // ChatView
    weak var chatView: UIView?
    // 좋아요 버튼 클릭 시 출력될 하트 리스트
    var heartList = [UIImageView]()
    // 썸네일 클릭 시 프로필을 보여주기 위해 유저 정보를 담은 객체
    var memInfo = MemberInfo()
    // Lottie Animation View
    var animationView: AnimationView?
    // 좋아요 버튼 활성화 타이머
    weak var likeTimer: Timer?
    // 채팅메세지, 시스템메세지를 담은 리스트
    var list = [ChatModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Constants
    // 채팅 입력창 placeholder
    let placeholder = "대화를 입력하세요"
    // Animation Total Time
    let animationTotalTime = 6.0
    // CustomColor Manager
    let colorManager = ColorManager.instance
    // SocketManager
    let socketManager = ChatSocketManager.instance
    // LikeButton On, Off
    let likeOn = UIImage(named: "btn_bt_heart_on")
    let likeOff = UIImage(named: "btn_bt_heart_off")
    // ChatViewModel
    let viewModel = ChatViewModel()
    // WebP이미지 디코딩을 위한 코더
    let WebPCoder = SDImageWebPCoder.shared
    // API Manager
    let apiManager = JoinApiManager(service: APIServiceProvider())
    let disposeBag = DisposeBag()
    
    // MARK: IBOutlet
    // 채팅 입력창
    @IBOutlet weak var chatSuperView: UIView!
    // 채팅 입력 텍스트뷰
    @IBOutlet weak var textSuperView: UIView!
    @IBOutlet weak var textView: UITextView!
    // 보내기 버튼
    @IBOutlet weak var sendButton: UIButton!
    // 좋아요 버튼
    @IBOutlet weak var likeButton: UIButton!
    // 채팅 리스트
    @IBOutlet weak var tableView: UITableView!
    // 아래로 이동 버튼
    @IBOutlet weak var downButton: UIButton!
    // 채팅 입력창 하단 Constraint
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // 채팅방 나가기 버튼 (우측 상단)
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
    
    deinit {
        print("ChatView Deinit")
    }
    
    // 뷰가 로드된 후 블러처리를 해줌
    override func draw(_ rect: CGRect) {
        setTableViewGradient()
    }
    
    // MARK: Function
    private func initialize() {
        self.chatView = Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)?.first as? UIView
        chatView?.frame = self.bounds
        self.addSubview(chatView!)
        
        setTextView()
        
        setGestureRecognizer()
        
        setTableView()
        
        setKeyboardNoti()
        
        setBackground()
        
        setSocketHandler()
        
        setLottieAnimation()
    }
    
    // Model -> ViewModel : Input
    // ViewModel transform 데이터 처리
    // ViewModel -> Model : Output
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
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.socketManager.sendChatMessage($0.chat!)
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
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.list.removeAll()
                self.removeFromSuperview()
                self.socketManager.serviceProvider?.disconnection()
                
            })
            .disposed(by: disposeBag)
        
        output.likeAnimation
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.socketManager.sendLike()
                
                self.likeButton.setImage(self.likeOff, for: .normal)
                self.likeButton.isEnabled = false
                self.likeButton.alpha = 0.5
                self.animationView?.stop()
                self.startLikeButtonTimer()
            })
            .disposed(by: disposeBag)
        
    }
}
