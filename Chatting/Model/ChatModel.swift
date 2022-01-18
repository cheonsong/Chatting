//
//  ChatModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import UIKit

class ChatModel {
    var chat: String?
    var nickname: String?
    var image: UIImage?
    
    init() {
        self.chat = ""
        self.nickname = "cheonsong"
    }
    
    init(chat: String) {
        self.chat = chat
        self.nickname = "cheonsong"
    }
}
