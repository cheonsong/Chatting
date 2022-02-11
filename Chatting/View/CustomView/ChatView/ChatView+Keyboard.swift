//
//  ChatView+Keyboard.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension ChatView {
    
    func setKeyboardNoti() {
        //키보드 알림 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    func removeKeyboardNoti() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @objc func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let adjustmentHeight = keyboardFrame.height - (chatView?.safeAreaInsets.bottom)!
        if noti.name == UIResponder.keyboardWillShowNotification {
            // 키보드가 올라오면 제약조건을 걸어줘 뷰의 위치를 재조정함
            bottomConstraint.constant = adjustmentHeight + 11
            sendButton.isHidden = false
            if Constant.chatPlaceholder == textView.text {
                textView.textColor = ColorManager.color51
                textView.text = ""
            }
            
        }
        else {
            // 키보드가 내려가면 제약조건을 0으로 걸어줌
            bottomConstraint.constant = 15
            sendButton.isHidden = true
            if(textView.text.isEmpty) {
                textView.text = Constant.chatPlaceholder
                textView.textColor = ColorManager.color203
            }
        }
    }
    
}
