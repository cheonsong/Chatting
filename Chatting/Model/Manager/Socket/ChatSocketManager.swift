//
//  SocketManager.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/25.
//

import Foundation
import SocketIO
import RxCocoa

class ChatSocketManager: ChatSocketService {
    
    // 입장 가능한 채팅방이 하나이므로 싱글톤 사용
    static let instance: ChatSocketManager = ChatSocketManager(service: SocketServiceProvider())
    
    var serviceProvider: SocketService?
    
    // 서버로부터 받는 이벤트 메세지
    var event: String = "message"
    
    private init(service: SocketService) {
        serviceProvider = service
        print("ChatSocketManager init")
    }
    
    deinit {
        print("ChatSocketManager deinit")
    }
    
    func roomEnter(_ memId: String, _ chatName: String, _ memPhoto: String, _ callback: @escaping AckCallback) {
        serviceProvider?.socket?.emitWithAck(event, ["cmd"       : "reqRoomEnter",
                                                     "mem_id"    : memId,
                                                     "chat_name" : chatName,
                                                     "mem_photo" : memPhoto
                                                    ]).timingOut(after: 1.0, callback: callback)
    }
    
    
    func roomOut(_ callback: @escaping AckCallback) {
        serviceProvider?.socket?.emitWithAck(event, ["cmd" : "reqRoomOut"])
            .timingOut(after: 1.0, callback: callback)
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
