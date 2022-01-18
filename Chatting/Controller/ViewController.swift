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
    
    let disposeBag = DisposeBag()
    //let touch: UITapGestureRecognizer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "background")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = self.view.bounds
        
        view.insertSubview(imageView, at: 0)
        
        view.addSubview(chatView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == chatView {
            print("touch")
        }
    }
    
}

