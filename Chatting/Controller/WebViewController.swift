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
import NaverThirdPartyLogin
import Alamofire

class WebViewController: UIViewController {
    
    var bridge: WKWebViewJavascriptBridge?
    var kakaoEmail: String = ""
    var naverEmail: String = ""
    var apiManager: JoinApiService?
    let memInfo = MemberInfo()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let socketManager = ChatSocketManager.getInstance()
    let colorManager = ColorManager.getInstance()
    
    
    private lazy var joinView = JoinView(frame: self.view.bounds)
    private lazy var profileView = ProfileView(frame: self.view.bounds)
    private lazy var chatView = ChatView(frame: self.view.bounds)
    
    @IBOutlet weak var wk: WKWebView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func tapChatButton(_ sender: Any) {
        socketManager.serviceProvider?.establishConnection()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.socketManager.roomEnter(self.memInfo.email!, self.memInfo.name!, self.memInfo.profileImage!) { ack in
                let json = JSON(ack.first!)
                if(json["success"].stringValue == "y") {
                    
                    self.view.addSubview(self.chatView)
                }
            }
        })
    }
    @IBAction func tapBackButton(_ sender: Any) {
        load()
        
        if kakaoEmail != "" {
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
        } else {
            loginInstance?.requestDeleteToken()
        }
        
        backButton.isHidden = true
        chatButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager = JoinApiManager(service: APIServiceProvider())
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: wk)
        
        loginInstance?.delegate = self
        
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
            guard let data = data as? Dictionary<String, String> else { return }
            guard let cmd = data["cmd"] else { return }
            switch (cmd) {
            case "loginKakao":
                UserApi.shared.loginWithKakaoAccount(prompts: [.Login], completion:  {(token, err) in
                    UserApi.shared.me(completion: { (user, err) in
                        print("******************************카카오 이메일**************************************")
                        self.kakaoEmail = (user?.kakaoAccount?.email) ?? ""
                        print(self.kakaoEmail)
                        self.apiManager?.getMembershipStatus(self.kakaoEmail, completion: { result in
                            print(result)
                            self.memInfo.age = result["mem_info"]["age"].stringValue
                            self.memInfo.email = result["mem_info"]["email"].stringValue
                            self.memInfo.contents = result["mem_info"]["contents"].stringValue
                            self.memInfo.name = result["mem_info"]["name"].stringValue
                            self.memInfo.gender = result["mem_info"]["gender"].stringValue
                            self.memInfo.profileImage = result["mem_info"]["profile_image"].stringValue
                            
                            result["is_member"].rawValue as! Bool ? self.goToProfileList() : self.goToJoinView()
                        })
                    })
                })
                
            case "loginNaver":
                print("naver")
                self.loginInstance?.requestThirdPartyLogin()
                
                
                
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
                        self.profileView.sexAgeView.layer.borderColor = self.colorManager.profileManSexAgeBorderColor.cgColor
                        self.profileView.ageLabel.textColor = self.colorManager.profileSexLabeltextColor
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
        joinView.kakaoEmail = kakaoEmail
        joinView.naverEmail = naverEmail
        self.view.addSubview(joinView)
    }
    
    func goToProfileList() {
        print("gotochat")
        if kakaoEmail != "" {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(kakaoEmail)")!))
        } else {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(naverEmail)")!))
        }
        chatView.memInfo = self.memInfo
        chatButton.isHidden = false
        backButton.isHidden = false
    }
}


