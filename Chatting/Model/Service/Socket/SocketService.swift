//
//  SocketService.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/25.
//

import Foundation
import SocketIO

protocol SocketService {
    
    var manager: SocketManager? { get }
    var socket: SocketIOClient? { get }
    
    // 소켓 연결
    func establishConnection()
    
    func disconnection()
}
