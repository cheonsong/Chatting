//
//  SocketManager.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/25.
//

import Foundation
import SocketIO

class ChatSocketManager {
    
    static let instance = ChatSocketManager(service: SocketServiceProvider())
    
    var serviceProvider: SocketService?
    
    let event = "message"
    private init(service: SocketService) {
        serviceProvider = service
        
    }
    
    func roomEnter(_ memId: String, _ chatName: String, _ memPhoto: String, _ callback: @escaping AckCallback) {
        serviceProvider?.socket?.emitWithAck(event, ["cmd"       : "reqRoomEnter",
                                                     "mem_id"    : memId,
                                                     "chat_name" : chatName,
                                                     "mem_photo" : memPhoto
                                                    ]).timingOut(after: 1.0, callback: callback)
    }
    
    
    func roomOut() {
        serviceProvider?.socket?.emit(event, ["cmd" : "reqRoomOut"]) {
            print("Emit : roomOut")
        }
    }
    
    
    func sendChatMessage(_ msg: String) {
        serviceProvider?.socket?.emit(event, ["cmd" : "sendChatMsg",
                                              "msg" :  msg
                                             ]) {
            print("Emit2 : " + msg + " 전송")
        }
    }
    
    func sendLike() {
        serviceProvider?.socket?.emit(event, ["cmd" : "sendLike"]) {
            print("Emit : sendLike")
        }
    }
    
}
