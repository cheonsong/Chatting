//
//  JoinView+Keyboard.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/19.
//

import Foundation
import UIKit

extension JoinView {
    
    func setKeyboardNoti() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardWillShow")
            if self.frame.origin.y == 0{
                self.frame.origin.y -= keyboardSize.height
                if Constant.introducePlaceholder == introduceTextView.text {
                    introduceTextView.text = ""
                    introduceTextView.textColor = ColorManager.color17
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
            if introduceTextView.text.isEmpty {
                introduceTextView.text = Constant.introducePlaceholder
                introduceTextView.textColor = ColorManager.color191
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification?) {
        print("keyboardWillChangeFrame")
        if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y != 0 {
                print(frame.origin.y)
                print(keyboardSize.height)
                self.frame.origin.y = -keyboardSize.height
            }
        }
    }
}
