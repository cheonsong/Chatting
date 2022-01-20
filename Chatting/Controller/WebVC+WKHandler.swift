//
//  WebVC+WKHandler.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import WebKit

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "loginKakao":
            print("loginKakao")
        case "loginNaver":
            print("loginNaver")
        default:
            break
        }
    }
}
