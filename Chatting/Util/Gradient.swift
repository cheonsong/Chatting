//
//  Gradient.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/10.
//

import Foundation
import UIKit

// 그라데이션 버튼 만들기

extension UIButton {
    
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.cornerRadius = self.frame.height / 2
        
        layer.insertSublayer(gradient, at: 0)
        
    }
    
}

extension UIView {
    func setViewGradient(color1:UIColor,color2:UIColor) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        
        layer.mask = gradient
    }
}
