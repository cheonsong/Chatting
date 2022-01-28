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
import Lottie
import SDWebImageWebPCoder

class ChatView: UIView{
    
    // MARK: Property
    
    // 채팅 입력창 placeholder
    let placeholder = "대화를 입력하세요"
    // Animation Total Time
    let animationTotalTime = 6.0
    // CustomColor Manager
    let colorManager = ColorManager.getInstance()
    // SocketManager
    let socketManager = ChatSocketManager.getInstance()
    
    // ChatView
    var view: UIView?
    // ChatViewModel
    let viewModel = ChatViewModel()
    // 채팅메세지, 시스템메세지를 담은 리스트
    var list = [ChatModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    // 좋아요 버튼 클릭 시 출력될 하트 리스트
    var heartList = [UIImageView]()
    // WebP이미지 디코딩을 위한 코더
    let WebPCoder = SDImageWebPCoder.shared
    // 썸네일 클릭 시 프로필을 보여주기 위해
    // 유저 정보를 담은 객체
    var memInfo = MemberInfo()
    // API Manager
    var apiManager = JoinApiManager(service: APIServiceProvider())
    // Lottie Animation View
    var animationView: AnimationView?
    // Animator for Like Animation
    
    
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
    
//    deinit {
//        print("ChatView Deinit")
//    }
    
    // 뷰가 로드된 후 블러처리를 해줌
    override func draw(_ rect: CGRect) {
        setTableViewGradient()
    }
    
    // MARK: Function
    private func initialize() {
        self.view = Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
        
        SDImageCodersManager.shared.addCoder(WebPCoder)
        
        setTextView()
        
        setGestureRecognizer()
        
        setTableView()
        
        setKeyboardNoti()
        
        setBackground()
        
        setSocketHandler()
        
        setLottieAnimation()
        
        setAnimationHeart()
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
            .subscribe(onNext: {
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
            .subscribe(onNext: {
                self.socketManager.roomOut { [weak self] ack in
                    print("roomOut")
                    let json = JSON(ack.first!)
                    if(json["success"].stringValue == "y") {
                        self?.list.removeAll()
                        self?.removeFromSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.likeAnimation
            .subscribe(onNext: { //[weak self] in
                self.socketManager.sendLike()
            })
            .disposed(by: disposeBag)
        
    }
    
    // "message" 핸들로러 온 이벤트 처리
    func setSocketHandler() {
        self.socketManager.serviceProvider?.socket?.on("message", callback: { data, ack in
            print(data)
            guard let dataInfo = data.first else { return }
            let json = JSON(dataInfo)
            switch (json["cmd"].stringValue) {
                
                // 시스템 메세지
            case "rcvSystemMsg":
                print(json["msg"].stringValue)
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
    
    // Lottie Animation
    private func setLottieAnimation() {
        animationView = AnimationView(name: "ani_live_like_full")
        animationView?.frame = CGRect(x: 0, y: likeButton.frame.origin.y, width: 36, height: 36)
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        self.likeButton.addSubview(animationView!)
        animationView?.isUserInteractionEnabled = false
        animationView?.play()
        
    }
    
    // 좋아요 버튼 클릭 시 올라오는 하트 이미지
    private func setAnimationHeart() {
        
        (0...6).forEach { _ in heartList.append(UIImageView()) }
        
        var i = 0
        
        heartList.forEach {
            // heart frame 설정
            $0.frame = CGRect(x: Int(arc4random() % 60), y: Int((view?.frame.height)!) - Int(arc4random() % 80), width: 50, height: 50)
            
            // heart image 추가
            $0.sd_setImage(with: URL(string: "file:///Users/yeoboya_211221_03/Desktop/likeAnimationImageFile/an_like_0\(i+1).webp")!)
            i =  (i + 1) % 5
            
            // heart image 투명도 0
            $0.alpha = 0
            
            // heartview 올리기
            self.view?.addSubview($0)
        }
    }
    
    private func setAnimation() {
        
    }
}
