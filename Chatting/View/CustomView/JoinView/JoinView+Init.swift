//
//  JoinView+Set.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import UIKit

extension JoinView {
    
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
        imageView.layer.cornerRadius = 10
    }
    
    func setBorderColor() {
        topView.layer.addBorder([.bottom], color: ColorManager.color223, width: 1)
        pictureView.layer.borderColor = ColorManager.color223.cgColor
        textField.layer.borderColor = ColorManager.color223.cgColor
        manButton.layer.borderColor = ColorManager.color223.cgColor
        womanButton.layer.borderColor = ColorManager.color223.cgColor
        yearView.layer.borderColor = ColorManager.color223.cgColor
        monthView.layer.borderColor = ColorManager.color223.cgColor
        dayView.layer.borderColor = ColorManager.color223.cgColor
        introduceSuperView.layer.borderColor = ColorManager.color223.cgColor
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
        textField.textColor = ColorManager.color99
        introduceTextView.textColor = ColorManager.color191
    }
    
    func setDelegate() {
        self.imagePicker.delegate = self
        self.introduceTextView.delegate = self
    }
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.name = "EndEditing"
        tapGesture.delegate = self
        self.bottomView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer()
        tapGesture2.name = "EndEditing"
        tapGesture2.delegate = self
        self.profileImageSuperView.addGestureRecognizer(tapGesture2)
        
        let imageGesture = UITapGestureRecognizer()
        imageGesture.name = "ImagePick"
        imageGesture.delegate = self
        self.pictureView.addGestureRecognizer(imageGesture)
        
        let yearGesture = UITapGestureRecognizer()
        yearGesture.name = "Year"
        yearGesture.delegate = self
        self.yearView.addGestureRecognizer(yearGesture)
        
        let monthGesture = UITapGestureRecognizer()
        monthGesture.name = "Month"
        monthGesture.delegate = self
        self.monthView.addGestureRecognizer(monthGesture)
        
        let dayGesture = UITapGestureRecognizer()
        dayGesture.name = "Day"
        dayGesture.delegate = self
        self.dayView.addGestureRecognizer(dayGesture)

    }
    
}
