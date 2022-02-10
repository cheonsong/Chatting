//
//  JoinView+TextView.swift
//  Chatting
//
//  Created by cheonsong on 2022/02/10.
//

import Foundation
import UIKit

extension JoinView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count + text.count - range.length
        return newLength <= 200
    }
}
