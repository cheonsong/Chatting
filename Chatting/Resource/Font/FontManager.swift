//
//  FontManager.swift
//  SnapkitProject
//
//  Created by cheonsong on 2022/02/04.
//

import Foundation
import UIKit

struct FontManager {
    
    static let instance = FontManager()
    
    private init() {}
    
    enum NotoSansKR {
        case light
        case bold
        case thin
        case black
        case medium
        case regular
    }
    
    func NotoSansKR(_ type: NotoSansKR ,_ size: CGFloat)-> UIFont {
        switch type {
        case .light :
            return UIFont(name: "NotoSansKR-Light", size: size)!
        case .bold :
            return UIFont(name: "NotoSansKR-Bold", size: size)!
        case .thin :
            return UIFont(name: "NotoSansKR-Thin", size: size)!
        case .black :
            return UIFont(name: "NotoSansKR-Black", size: size)!
        case .medium :
            return UIFont(name: "NotoSansKR-Medium", size: size)!
        case .regular :
            return UIFont(name: "NotoSansKR-Regular", size: size)!
        }
    }
}
