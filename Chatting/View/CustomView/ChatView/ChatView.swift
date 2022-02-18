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
    weak var animationView: AnimationView?
    // 좋아요 버튼 활성화 타이머
    weak var likeTimer: Timer?
    // 채팅메세지, 시스템메세지를 담은 리스트
    var list = [ChatModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    var animator1: UIViewPropertyAnimator?
    var animator2: UIViewPropertyAnimator?
    var animator3: UIViewPropertyAnimator?
    var likeFlag: Bool = true
    
    // MARK: Constants
    // LikeButton On, Off
    let likeOn = UIImage(named: "btn_bt_heart_on")
    let likeOff = UIImage(named: "btn_bt_heart_off")
    // ChatViewModel
    let viewModel = ChatViewModel()
    // API Manager
    let apiManager = JoinApiManager(service: APIServiceProvider())
    var disposeBag = DisposeBag()
    
    // MARK: IBOutlet
    @IBOutlet weak var stackView: UIStackView!
    // 채팅 입력창
    @IBOutlet weak var bottomView: UIView!
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
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.initialize()
        self.bindViewModel()
        self.bindUI()
    }
    
    deinit {
        print("ChatView Deinit")
        //disposeBag = DisposeBag()
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
        
        print("ChatView init")
        
        likeButton.setImage(likeOn, for: .normal)
        
        // ChatView+Init 파일에 구현
        setTextView()
        
        setGestureRecognizer()
        
        setTableView()
        
        setKeyboardNoti()
        
        setBackground()
        
        setSocketHandler()
        
        setLottieAnimation()
        
        setLikeAnimation()
    }
    
    // MARK: BindViewModel (event 발생 시 데이터를 변환하거나 UI와 관련없는 작업이 필요할 시)
    
    // Model -> ViewModel : Input
    // ViewModel transform 데이터 처리
    // ViewModel -> Model : Output
    private func bindViewModel() {
        
        let input = ChatViewModel.Input(
            chatText: textView.rx.text.orEmpty.asObservable(),
            tapSendButton: sendButton.rx.tap.asObservable(),
            taplikeButton: likeButton.rx.tap.asObservable(),
            tapCancelButton: cancelButton.rx.tap.asObservable().share()
        )
        
        let output = viewModel.transform(input: input)
        
        // 뷰에 바인딩 시켜주기
        
        // likeFlag
        // TRUE: 좋아요 버튼 이미지 활성화
        // FALSE: 좋아요 버튼 이미지 비활성화
        output.likeFlag
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: BindUI (event 발생 시 단순히 UI만 바뀌는 경우)
    private func bindUI() {
        // scrollDown
        // 아래로버튼 클릭 시 가장 최근에 대화로 이동
        downButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            .disposed(by: disposeBag)
        
        // removeTextInTextView
        // 채팅을 보내면 입력창의 텍스트 초기화
        // 가장 최신 대화로 이동
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.textView.text = ""
            })
            .disposed(by: disposeBag)
        
        // deleteView
        // 채팅방 나가기
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.likeTimer?.invalidate()
                self.likeTimer = nil
                self.list.removeAll()
                self.animator1?.stopAnimation(true)
                self.removeFromSuperview()
                
            })
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if self.likeButton.image(for: .normal)!.isEqual(self.likeOn) {
                    ChatSocketManager.instance.sendLike()
                    self.likeButton.setImage(self.likeOff, for: .normal)
                    self.animationView?.stop()
                    self.animationView?.isHidden = true
                    self.startLikeButtonTimer()
                } else {
                    print("nonoononononoononon")
                }
            })
            .disposed(by: disposeBag)
        
    }
}
