//
//  Color.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/13.
//

import Foundation
import UIKit

struct ColorManager {
    
    func makeColor(rgb: CGFloat)-> UIColor {
        let RGB = rgb / 255
        return UIColor(red: RGB, green: RGB, blue: rgb, alpha: 1)
    }
    
    func makeColor(r: CGFloat, g: CGFloat, b: CGFloat)-> UIColor {
        let red = r / 255
        let green = g / 255
        let blue = b / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static let color17 = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    static let color51 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    static let color99 = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    static let color102 = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    static let color164 = UIColor(red: 164/255, green: 164/255, blue: 164/255, alpha: 1)
    static let color191 = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
    static let color203 = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1)
    static let color223 = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
    static let color238 = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    static let gradientStartColor = UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 1)
    static let gradientFinishColor = UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1)
    static let fmColor = UIColor(red: 241/255, green: 238/255, blue: 255/255, alpha: 1)
    static let manButtonColor = UIColor(red: 184/255, green: 217/255, blue: 255/255, alpha: 1)
    static let womanButtonColor = UIColor(red: 255/255, green: 230/255, blue: 240/255, alpha: 1)
    static let womanButtonBorder = UIColor(red: 255/255, green: 152/255, blue: 193/255, alpha: 1)
    static let profileLikeBorderColor = UIColor(red: 255/255, green: 228/255, blue: 228/255, alpha: 1)
    static let profileWomanSexAgeBorderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1)
    static let locationViewBorderColor = UIColor(red: 202/255, green: 221/255, blue: 239/255, alpha: 1)
    static let profileSexLabeltextColor = UIColor(red: 93/255, green: 126/255, blue: 232/255, alpha: 1)
    static let profileManSexAgeBorderColor = UIColor(red: 200/255, green: 211/255, blue: 249/255, alpha: 1)
    static let joinButtonGradientStart = UIColor(red: 133/255, green: 139/255, blue: 255/255, alpha: 1)
    static let joinButtonGradientFinish = UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1)
}
