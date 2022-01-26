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
        manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!)
        
        socket = manager?.defaultSocket
        
        establishConnection()
    }
    
    func establishConnection() {
        socket?.connect()
    }
    
    func disconnection() {
        socket?.disconnect()
    }
    
}
