//
//  ViewController.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private lazy var chatView = ChatView(frame: self.view.frame)
    private lazy var joinView = JoinView(frame: self.view.frame)
    
    @IBAction func tapChatRoom(_ sender: Any) {
        view.addSubview(chatView)
    }
    @IBAction func tapJoinButton(_ sender: Any) {
        view.addSubview(joinView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

