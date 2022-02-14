//
//  ChatView+Init.swift
//  Chatting
//
//  Created by cheonsong on 2022/02/07.
//

import Foundation
import UIKit
import SwiftyJSON
import Lottie
import SnapKit
import Then

extension ChatView {
    
    // "message" 핸들로러 온 이벤트 처리
    func setSocketHandler() {
        ChatSocketManager.instance.serviceProvider?.socket?.on("message", callback: { [weak self] data, ack in
            
            guard let self = self else { return }
            
            print(data)
            guard let dataInfo = data.first else { return }
            let json = JSON(dataInfo)
            switch (json["cmd"].stringValue) {
                
                // 시스템 메세지
            case "rcvSystemMsg":
                print(json["msg"].stringValue)
                let chat = ChatModel(chat: json["msg"].stringValue, type: .system)
                self.list.insert(chat, at: 0)
                
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
                // 채팅 메세지
            case "rcvChatMsg":
                let chat = ChatModel(chat: json["msg"].stringValue, type: .user)
                chat.nickname = json["from"]["chat_name"].stringValue
                chat.imageLink = json["from"]["mem_photo"].url
                chat.email = json["from"]["mem_id"].stringValue
                print("=====================rcvChatMsg=====================")
                self.list.insert(chat, at: 0)
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                
                // 토스트 메세지
            case "rcvToastMsg":
                print("토스트 메세지 : " + json["msg"].stringValue)
                let alert = UIAlertController(title: "알림", message: json["msg"].stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인" , style: .default, handler: nil))
                
                getRootViewController()?.present(alert, animated: false, completion: nil)
                
                // 알림 메세지
            case "rcvAlertMsg":
                print("알림 : " + json["msg"].stringValue)
                let alert = UIAlertController(title: "알림", message: json["msg"].stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인" , style: .default, handler: nil))
                
                getRootViewController()?.present(alert, animated: false, completion: nil)
                
                // 좋아요 애니메이션 메세지
            case "rcvPlayLikeAni":
                print("좋아요 에니메이션 하세요")
                
                if self.animator?.state.rawValue == 0 {
                    self.heartList.removeAll()
                    self.setAnimationHeart()
                    self.setHeartTapGesture()
                    self.setLikeAnimation()
                    self.animator?.startAnimation()
                }
                
            default:
                print("default")
            }
        })
    }
    
    // 배경을 이미지뷰로 교체
    func setBackground() {
        let image = UIImage(named: "background")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = self.bounds
        insertSubview(imageView, at: 0)
    }
    
    // 텍스트 뷰 초기화
    func setTextView() {
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 18
        textView.text = Constant.chatPlaceholder
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 7.5, left: 15, bottom: 0, right: 15)
        textView.tintColor = .lightGray
    }
    
    // Lottie Animation
    func setLottieAnimation() {
        animationView = AnimationView(name: "ani_live_like_full").then {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.frame = CGRect(x: 0, y: likeButton.frame.origin.y, width: 36, height: 36)
        }
        
        self.likeButton.addSubview(animationView!)
        
        //        animationView?.snp.makeConstraints {
        //            $0.edges.equalTo(likeButton)
        //        }
        
        animationView?.isUserInteractionEnabled = false
        animationView?.play()
        
    }
    
    // 좋아요 버튼 클릭 시 올라오는 하트 이미지 초기화
    func setAnimationHeart() {
        
        (0...6).forEach { _ in heartList.append(UIImageView()) }
        
        var i = 0
        
        heartList.forEach {
            // heart frame 설정
            $0.frame = CGRect(x: Int(arc4random() % 60), y: Int((chatView?.frame.height)!) - Int(arc4random() % 80), width: 50, height: 50)
            
            // heart image 추가
            let filename = "an_like_0\(i+1)"
            let fileType = "webp"
            let url = Bundle.main.url(forResource: filename, withExtension: fileType)
            $0.sd_setImage(with: url)
            i =  (i + 1) % 5
            
            // heart image 투명도 0
            $0.alpha = 0
            $0.isUserInteractionEnabled = true
            // heartview 올리기
            self.chatView?.addSubview($0)
        }
        
    }
    
    func setHeartTapGesture() {
        heartList.forEach {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.name = "like"
            tapGesture.delegate = self
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    func setLikeAnimation() {
        animator = UIViewPropertyAnimator(duration: Constant.animationTotalTime, curve: .easeInOut)
        animator?.addAnimations { [weak self] in
            guard let self = self else { return }
            UIView.animateKeyframes(withDuration: Constant.animationTotalTime, delay: 0, options: [.calculationModePaced, .allowUserInteraction], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                    self.heartList.forEach({
                        $0.alpha = 1
                        $0.frame = CGRect(x: $0.frame.origin.x - CGFloat(arc4random() % 75), y: $0.frame.origin.y - CGFloat((arc4random() % 50) + 100), width: 50, height: 50)
                    })
                })
                
                
                
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.55, animations: {
                    self.heartList.forEach({
                        
                        let option:CGFloat = arc4random() % 2 == 0 ? -1 : 1
                        
                        $0.frame = CGRect(x: $0.frame.origin.x + (option * CGFloat(arc4random() % 75)),
                                          y: $0.frame.origin.y - CGFloat((arc4random() % 50) + 200),
                                          width: $0.frame.width + CGFloat((arc4random() % 10)) + 20,
                                          height: $0.frame.height + CGFloat((arc4random() % 10)) + 20)
                    })
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                    self.heartList.forEach({
                        
                        let option:CGFloat = arc4random() % 2 == 0 ? -1 : 1
                        
                        $0.frame = CGRect(x: $0.frame.origin.x + (option * CGFloat(arc4random() % 75)),
                                          y: CGFloat(arc4random() % 80),
                                          width: $0.frame.width + 20,
                                          height: $0.frame.height + 20)
                        
                        $0.alpha = 0.05
                    })
                })
            })
        }
        
        animator?.addCompletion { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .current:
                print("current")
            case .end:
                self.heartList.forEach {
                    $0.removeFromSuperview()
                }
            case .start:
                print("start")
            @unknown default:
                fatalError()
            }
        }
    }
    
    // 좋아요 버튼 활성화 타이머
    func startLikeButtonTimer() {
        print("Timer 작동 작동 작동 Timer 작동 작동 작동 Timer 작동 작동 작동 Timer 작동 작동 작동 Timer 작동 작동 작동")
        likeTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { [weak self] (Timer) in
            guard let self = self else { return }
            
            self.likeButton.setImage(self.likeOn, for: .normal)
            self.animationView?.isHidden = false
            self.animationView?.play()
        })
    }
}
