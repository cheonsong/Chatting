//
//  ChatSocketService.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/27.
//

import Foundation
import SocketIO

protocol ChatSocketService: AnyObject {
    
    // 방 들어가기
    func roomEnter(_ memId: String, _ chatName: String, _ memPhoto: String, _ callback: @escaping AckCallback)
    
    // 방 나가기
    func roomOut(_ callback: @escaping AckCallback)
    
    // 채팅 메세지 보내기
    func sendChatMessage(_ msg: String)
    
    // 좋아요 애니메이션 보내기
    func sendLike()
}
