//
//  JoinView+Set.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import UIKit

extension JoinView {
    
    func setKeyboardNoti() {
        //키보드 알림 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    func setCornerRadius() {
        pictureView.layer.cornerRadius = 10
        textField.layer.cornerRadius = 5
        manButton.layer.cornerRadius = 5
        womanButton.layer.cornerRadius = 5
        yearView.layer.cornerRadius = 5
        monthView.layer.cornerRadius = 5
        dayView.layer.cornerRadius = 5
        introduceSuperView.layer.cornerRadius = 4
        joinButton.layer.cornerRadius = joinButton.frame.height / 2
    }
    
    func setBorderColor() {
        topView.layer.addBorder([.bottom], color: colorManager.color223, width: 1)
        pictureView.layer.borderColor = colorManager.color223.cgColor
        manButton.layer.borderColor = colorManager.color223.cgColor
        womanButton.layer.borderColor = colorManager.color223.cgColor
        yearView.layer.borderColor = colorManager.color223.cgColor
        monthView.layer.borderColor = colorManager.color223.cgColor
        dayView.layer.borderColor = colorManager.color223.cgColor
        introduceSuperView.layer.borderColor = colorManager.color223.cgColor
    }
    
    func setBorderWidth() {
        pictureView.layer.borderWidth = 1
        textField.layer.borderWidth = 1
        manButton.layer.borderWidth = 1
        womanButton.layer.borderWidth = 1
        yearView.layer.borderWidth = 1
        monthView.layer.borderWidth = 1
        dayView.layer.borderWidth = 1
        introduceSuperView.layer.borderWidth = 1
    }
    
    func setTextColor() {
        textField.textColor = colorManager.color99
        introduceTextView.textColor = colorManager.color191
    }
    
    func setDelegate() {
        self.imagePicker.delegate = self
    }
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view?.addGestureRecognizer(tapGesture)
    }
    
}
