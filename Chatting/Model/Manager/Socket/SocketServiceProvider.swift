//
//  SocketServiceProvider.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/25.
//

import Foundation
import SocketIO

class SocketServiceProvider: SocketService {
    
    var manager: SocketManager?
    var socket: SocketIOClient?
    
    
    init() {
        manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!, config: [.reconnects(false)])
        
        socket = manager?.defaultSocket
        print("SocketServiceProvider init")
        
        
    }
    
    deinit {
        print("SocketServiceProvider deinit")
    }
    
    // 채팅방이 여러개일경우 원하는 채팅방에 입장하기 위한 이니셜라이저
    // 이번 과제에서는 채팅방이 하나 이므로 사용하지는 않음
    init(url: String) {
        manager = SocketManager(socketURL: URL(string: url)!)
        
        socket = manager?.defaultSocket
    }
    
    func establishConnection() {
        socket?.connect()
    }
    
    func disconnection() {
        socket?.disconnect()
    }
    
}
