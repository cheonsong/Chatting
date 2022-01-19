//
//  LetterSpacing.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/10.
//

import Foundation
import UIKit

// 자간 간격 조절 함수

extension UILabel {
    func kern(spacing: Double) {
        let attrString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

extension UIButton {
    func kern(spacing: Double) {
        let attrString = NSMutableAttributedString(string: self.titleLabel?.text! ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.titleLabel?.attributedText = attrString
    }
}
