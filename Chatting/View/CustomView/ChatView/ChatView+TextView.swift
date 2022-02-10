//
//  ChatView+TextView.swift
//  Chatting
//
//  Created by cheonsong on 2022/02/10.
//

import Foundation
import UIKit

extension ChatView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        let size = CGSize(width: (textView.frame.width), height: .infinity)

        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count + text.count - range.length
        return newLength <= 100
    }
}
