//
//  ChatModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import UIKit

class ChatModel {
    var type: ChatType?
    var chat: String?
    var nickname: String?
    var imageLink: String?
    var email: String?
    
    init() {
        self.chat = ""
        self.nickname = "System"
        self.type = .system
    }
    
    init(chat: String, type: ChatType) {
        self.chat = chat
        self.nickname = "User"
        self.type = type
    }
    
    enum ChatType {
        case system
        case user
    }
}
