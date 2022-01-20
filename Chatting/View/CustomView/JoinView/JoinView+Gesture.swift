//
//  ChatView+gesture.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension JoinView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view?.endEditing(true)
        return true
    }
    

}
