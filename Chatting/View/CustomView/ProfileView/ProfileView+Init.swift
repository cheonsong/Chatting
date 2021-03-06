//
//  ProfileView+Init.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/21.
//

import Foundation
import UIKit

extension ProfileView {
    
    func setBackgroundColor() {
        sexAgeView.backgroundColor = .white
        locationView.backgroundColor = .white
        sexAgeSuperView.backgroundColor = .white
        cv.backgroundColor = .white
    }
    
    func setCornerRadius() {
        likeLabel.layer.cornerRadius = likeLabel.frame.height / 2
        bottomView.layer.cornerRadius = 25
        bottomView.clipsToBounds = true
        sexAgeView.layer.cornerRadius = sexAgeView.frame.height / 2
        locationView.layer.cornerRadius = locationView.frame.height / 2
        introduceView.layer.cornerRadius = 4
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    
    func setBorder() {
        sexAgeView.layer.borderColor = ColorManager.profileWomanSexAgeBorderColor.cgColor
        sexAgeView.layer.borderWidth = 1
        
        likeLabel.layer.borderColor = ColorManager.profileLikeBorderColor.cgColor
        likeLabel.layer.borderWidth = 1
        
        locationView.layer.borderColor = ColorManager.locationViewBorderColor.cgColor
        locationView.layer.borderWidth = 1
        
        introduceView.layer.borderColor = ColorManager.color238.cgColor
        introduceView.layer.borderWidth = 1
    }
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.topView.addGestureRecognizer(tapGesture)
    }
}
