//
//  ChatView+gesture.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension ChatView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            self.view?.endEditing(true)
            return true
        }
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.name = "tableViewTouch"
        tapGesture.delegate = self
        self.tableView?.addGestureRecognizer(tapGesture)
    }
}
