//
//  ChatView+gesture.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension ProfileView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let name = gestureRecognizer.name
        self.removeFromSuperview()
        return true
    }
    

}
