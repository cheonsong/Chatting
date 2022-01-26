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
    var imageLink: String? {
        didSet {
            image = UIImage(data: try! Data(contentsOf: URL(string: imageLink!)!))
        }
    }
    var image: UIImage?
    
    init() {
        self.chat = ""
        self.nickname = "System"
    }
    
    init(chat: String) {
        self.chat = chat
        self.nickname = "User"
        self.type = .user
    }
    
    enum ChatType {
        case system
        case user
    }
}
