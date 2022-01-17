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
    
    var list = [ChatModel]()
    let placeholder = "대화를 입력하세요"
    
    private lazy var chatView = ChatView(frame: self.view.frame)
    let viewModel = ChatViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chatView.textView.layer.cornerRadius = 18
        //chatView.sendButton.isHidden = true
        self.view = chatView
        
    }
}

