//
//  JoinView+Keyboard.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/19.
//

import Foundation
import UIKit

extension JoinView {
    
    
    
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
        let adjustmentHeight = keyboardFrame.height - (view?.safeAreaInsets.bottom)!
        if noti.name == UIResponder.keyboardWillShowNotification {
            // 키보드가 올라오면 제약조건을 걸어줘 뷰의 위치를 재조정함
            bottomConstraint.constant = adjustmentHeight
            introduceTextView.textColor = colorManager.color51
            introduceTextView.text = ""
            
        }
        else {
            // 키보드가 내려가면 제약조건을 0으로 걸어줌
            bottomConstraint.constant = 0
            introduceTextView.textColor = colorManager.color203
            if(introduceTextView.text.isEmpty) {
                introduceTextView.text = placeholder
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if self.frame.origin.y == 0{
                self.frame.origin.y -= keyboardSize.height
                if placeholder == introduceTextView.text {
                    introduceTextView.text = ""
                    introduceTextView.textColor = colorManager.color17
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
            if introduceTextView.text.isEmpty {
                introduceTextView.text = placeholder
                introduceTextView.textColor = colorManager.color191
            }
        }
    }
}
