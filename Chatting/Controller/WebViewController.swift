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
import SwiftyJSON
import RxSwift
import RxCocoa

class WebViewController: UIViewController {
    
    var bridge: WKWebViewJavascriptBridge?
    var kakaoEmail: String?
    var naverEmail: String?
    var apiManager: JoinApiService?
    private lazy var joinView = JoinView(frame: self.view.frame)
    private lazy var profileView = ProfileView(frame: self.view.frame)
    private lazy var chatView = ChatView(frame: self.view.frame)
    
    @IBOutlet weak var wk: WKWebView!
    @IBOutlet weak var chatButton: UIButton!

    @IBAction func tapChatButton(_ sender: Any) {
        self.view.addSubview(chatView)
    }
    
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
                        print("******************************카카오 이메일**************************************")
                        self.kakaoEmail = user?.kakaoAccount?.email
                        print(self.kakaoEmail!)
                        self.apiManager?.getMembershipStatus(self.kakaoEmail!, completion: { result in
                            print(result)
                            result["is_member"].rawValue as! Bool ? self.goToProfileList() : self.goToJoinView()
                        })
                    })
                })
                
            case "loginNaver":
                print("naver")
                
            case "open_profile":
                guard let userInfo = data["userInfo"] else { return }
                print("******************************프로필 열람**************************************")
                self.apiManager?.getMembershipStatus(userInfo, completion: { data in
                    let userInfo = data["mem_info"]
                    self.profileView.nameLabel.text = userInfo["name"].stringValue
                    self.profileView.ageLabel.text = userInfo["age"].stringValue
                    self.profileView.introduceLabel.text = userInfo["contents"].stringValue
                    do {
                        let imageData = try Data(contentsOf: URL(string: userInfo["profile_image"].stringValue)!)
                        self.profileView.profileImage.image = UIImage(data: imageData)
                    } catch {
                        self.profileView.profileImage.image = UIImage()
                    }
                    if userInfo["gender"].stringValue == "M" {
                        self.profileView.profileBorderImage.image = UIImage(named: "img_profile_line_m")
                        self.profileView.sexImage.image = UIImage(named: "ico_sex_m")
                        self.profileView.sexAgeView.layer.borderColor = CustomColor.instance.profileManSexAgeBorderColor.cgColor
                        self.profileView.ageLabel.textColor = CustomColor.instance.profileSexLabeltextColor
                    }
                    
                    self.view.addSubview(self.profileView)
                })
                
                
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
    
    func goToProfileList() {
        print("gotochat")
        wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(kakaoEmail ?? "")")!))
        chatButton.isHidden = false
    }
}
