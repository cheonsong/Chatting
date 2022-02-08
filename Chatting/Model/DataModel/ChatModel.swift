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
            do {
            image = UIImage(data: try Data(contentsOf: URL(string: imageLink!)!))
            } catch {
                image = UIImage()
            }
        }
    }
    var image: UIImage?
    var email: String?
    
    init() {
        self.chat = ""
        self.nickname = "System"
        self.type = .system
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
