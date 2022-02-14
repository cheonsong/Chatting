//
//  ChatView+gesture.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension ChatView: UIGestureRecognizerDelegate {
    
    // 채팅 입력중에 바깥화면을 터치하면 편집이 종료됨
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        print(gestureRecognizer.name)
        
        switch (gestureRecognizer.name) {
        case "tableViewTouch":
            self.chatView?.endEditing(true)
        
        case "like":
            print("like")
            likeFlag ? animator?.pauseAnimation() : animator?.startAnimation()
            likeFlag = !likeFlag
            
        default:
            print("default")
        }
        
        return true
    }
    
    // 바깥화면에는 채팅 입력 부분도 포함되기 때문에
    // 테이블뷰에만 적용되도록 명시
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.name = "tableViewTouch"
        tapGesture.delegate = self
        self.tableView?.addGestureRecognizer(tapGesture)
    }
}
