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
    
    private lazy var joinView = JoinView(frame: self.view.bounds)
    private lazy var profileView = ProfileView(frame: self.view.bounds)
    private lazy var chatView = ChatView(frame: self.view.bounds)
    
    @IBOutlet weak var wk: WKWebView!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBAction func tapChatButton(_ sender: Any) {
        ChatSocketManager.instance.roomEnter(memInfo.email!, memInfo.name!, memInfo.profileImage!) { ack in
            let json = JSON(ack.first!)
            if(json["success"].stringValue == "y") {
                self.view.addSubview(self.chatView)
            }
        }
        
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
                UserApi.shared.loginWithKakaoAccount(scopes: ["account_email"], completion: { (token, err) in
                    UserApi.shared.me(completion: { (user, err) in
                        print("******************************카카오 이메일**************************************")
                        self.kakaoEmail = (user?.kakaoAccount?.email) ?? ""
                        print(self.kakaoEmail)
                        self.apiManager?.getMembershipStatus("tjsrla77@naver.com", completion: { result in
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
                self.apiManager?.getMembershipStatus("tjsrla88@naver.com", completion: { result in
                    self.memInfo.age = result["mem_info"]["age"].stringValue
                    self.memInfo.email = result["mem_info"]["email"].stringValue
                    self.memInfo.contents = result["mem_info"]["contents"].stringValue
                    self.memInfo.name = result["mem_info"]["name"].stringValue
                    self.memInfo.gender = result["mem_info"]["gender"].stringValue
                    self.memInfo.profileImage = result["mem_info"]["profile_image"].stringValue
                    
                    result["is_member"].rawValue as! Bool ? self.goToProfileList() : self.goToJoinView()
                })
                
                
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
        joinView.kakaoEmail = kakaoEmail
        joinView.naverEmail = naverEmail
        self.view.addSubview(joinView)
    }
    
    func goToProfileList() {
        print("gotochat")
        if kakaoEmail != "" {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/tjsrla77@naver.com")!))
        } else {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/tjsrla88@naver.com")!))
        }
        chatView.memInfo = self.memInfo
        chatButton.isHidden = false
    }
}

extension WebViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
        
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    func getInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let email = object["email"] as? String else { return }
            
            self.naverEmail = email
            

        }
    }
}

