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

        print(gestureRecognizer.name ?? "")
        
        switch (gestureRecognizer.name) {
        case "like":
            if animator1?.state.rawValue == 1 {
                likeFlag ? animator1?.pauseAnimation() : animator1?.startAnimation()
            } else if animator2?.state.rawValue == 1 {
                likeFlag ? animator2?.pauseAnimation() : animator2?.startAnimation()
            } else if animator3?.state.rawValue == 1 {
                likeFlag ? animator3?.pauseAnimation() : animator3?.startAnimation()
            }
            
            likeFlag = !likeFlag
            
        case "tableViewTouch":
            self.chatView?.endEditing(true)
        
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
