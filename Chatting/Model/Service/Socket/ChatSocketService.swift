//
//  ChatSocketService.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/27.
//

import Foundation
import SocketIO

protocol ChatSocketService {
    
    func roomEnter(_ memId: String, _ chatName: String, _ memPhoto: String, _ callback: @escaping AckCallback)
    
    func roomOut(_ callback: @escaping AckCallback)
    
    func sendChatMessage(_ msg: String)
    
    func sendLike()
}
