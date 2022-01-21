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
import KakaoSDKUser

class WebViewController: UIViewController {
    
    var bridge: WKWebViewJavascriptBridge?
    var kakaoEmail: String?
    var naverEmail: String?
    var apiManager: JoinApiService?
    private lazy var joinView = JoinView(frame: self.view.frame)
    private lazy var profileView = ProfileView(frame: self.view.frame)
    
    @IBOutlet weak var wk: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager = JoinApiManager(service: APIServiceProvider())
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: wk)
        
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
            guard let data = data as? Dictionary<String, String> else { return }
            guard let cmd = data["cmd"] else { return }
            switch (cmd) {
            case "loginKakao":
                UserApi.shared.loginWithKakaoAccount(scopes: ["account_email"], completion: { (token, err) in
                    UserApi.shared.me(completion: { (user, err) in
                        print("******************************Kakao Email**************************************")
                        self.kakaoEmail = user?.kakaoAccount?.email
                        print(self.kakaoEmail!)
                        self.apiManager?.getMembershipStatus(self.kakaoEmail!, completion: { result in
                            print(result)
                            result ? self.goToChattingList() : self.goToJoinView()
                        })
                    })
                })
            case "loginNaver":
                print("naver")
            case "open_profile":
                print("Open Profile")
                self.view.addSubview(self.profileView)
            default:
                print("default")
            }
            responseCallback(data)
        })
        
        bridge?.callHandler(handlerName: "$.callFromWeb", data: nil, responseCallback: { (data) in
            print("Swift received response\(String(describing: data))")
        })
        
        load()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func load() {
        let request = URLRequest(url: URL(string: "http://babyhoney.kr/login")!)
        wk.load(request)
    }
    
    func goToJoinView() {
        joinView.kakaoEmail = kakaoEmail!
        self.view.addSubview(joinView)
    }
    
    func goToChattingList() {
        print("gotochat")
        wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(kakaoEmail ?? "")")!))
    }
}
