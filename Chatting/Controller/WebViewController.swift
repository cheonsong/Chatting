//
//  WebViewController.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import WebKit
import UIKit
import XHQWebViewJavascriptBridge

class WebViewController: UIViewController {
    
    @IBOutlet weak var wk: WKWebView!
    var bridge: WKWebViewJavascriptBridge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: wk)
        
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
        print("Swift Echo called with: \(String(describing: data))")
        responseCallback(data)
        })
        
        bridge?.callHandler(handlerName: "$.callFromWeb", data: nil, responseCallback: { (data) in
        print("Swift received response\(String(describing: data))")
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        load()
    }
    
    
    
    func load() {
        let request = URLRequest(url: URL(string: "http://babyhoney.kr/login")!)
        wk.load(request)
        
    }
    
}
