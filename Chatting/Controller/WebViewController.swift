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
    
    // MARK: Variables
    var bridge: WKWebViewJavascriptBridge?
    var kakaoEmail: String = ""
    var naverEmail: String = ""
    
    // MARK: Constants
    let apiManager = JoinApiManager(service: APIServiceProvider())
    // 회원정보를 담은 객체
    let memInfo = MemberInfo()
    // 네이버 로그인 인스턴스
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let socketManager = ChatSocketManager.instance
    let colorManager = ColorManager.instance
    
    @IBOutlet weak var wk: WKWebView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func tapChatButton(_ sender: Any) {
        socketManager.serviceProvider?.establishConnection()
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
        }
        backButton.isHidden = true
        chatButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: wk)
        
        // 네이버로그인 인스턴스
        loginInstance?.delegate = self
        
        setBridgeHandler()
        
        load()
        
        ChatSocketManager.instance.serviceProvider?.socket?.on(clientEvent: .disconnect, callback: { _, _ in
            print("disconnet")
        })
        
        ChatSocketManager.instance.serviceProvider?.socket?.on(clientEvent: .connect, callback: { [weak self] _, _ in
            guard let self = self else { return }
            print("connect")
            
            let chatView = ChatView(frame: self.view.bounds)
            
            chatView.memInfo = self.memInfo
            
            self.socketManager.roomEnter(self.memInfo.email!, self.memInfo.name!, self.memInfo.profileImage!) { ack in
                let json = JSON(ack.first!)
                if(json["success"].stringValue == "y") {
                    self.view.addSubview(chatView)
                }
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("WebVC DidDisappear")
    }
    
    deinit {
        print("WebVC deinit")
    }
    
    // 로그인 웹뷰 로드
    func load() {
        let request = URLRequest(url: URL(string: "http://babyhoney.kr/login")!)
        wk.load(request)
    }
    
    // 회원가입창으로 이동
    func goToJoinView() {
        print("Go To JoinView")
        let joinView = JoinView(frame: self.view.bounds)
        joinView.kakaoEmail = kakaoEmail
        joinView.naverEmail = naverEmail
        self.view.addSubview(joinView)
        
    }
    
    // 프로필리스트로 이동
    func goToProfileList() {
        print("Go To ProfileList")
        if kakaoEmail != "" {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(kakaoEmail)")!))
        } else {
            wk.load(URLRequest(url: URL(string: "http://babyhoney.kr/member/list/\(naverEmail)")!))
        }

        chatButton.isHidden = false
        backButton.isHidden = false
    }
    
    func setBridgeHandler() {
        // 브릿지 통신
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { [weak self] (data, responseCallback) in
            guard let self = self else { return }
            
            guard let data = data as? Dictionary<String, String> else { return }
            guard let cmd = data["cmd"] else { return }
            switch (cmd) {
                // 카카오 로그인 버튼 클릭시
            case "loginKakao":
                UserApi.shared.loginWithKakaoAccount(prompts: [.Login], completion:  { (token, err) in
                    
                    UserApi.shared.me(completion: { (user, err) in
                        print("******************************카카오 이메일**************************************")
                        self.kakaoEmail = (user?.kakaoAccount?.email) ?? ""
                        print(self.kakaoEmail)
                        self.apiManager.getMembershipStatus(self.kakaoEmail, completion: { result in
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
                
                // 네이버 로그인 버튼 클릭시
            case "loginNaver":
                print("naver")
                self.loginInstance?.requestThirdPartyLogin()
                
                // 프로필 열람 버튼 클릭시
            case "open_profile":
                guard let userInfo = data["userInfo"] else { return }
                print("******************************프로필 열람**************************************")
                let profileView = ProfileView(frame: self.view.bounds)
                self.apiManager.getMembershipStatus(userInfo, completion: { data in
                    let userInfo = data["mem_info"]
                    profileView.nameLabel.text = userInfo["name"].stringValue
                    profileView.ageLabel.text = userInfo["age"].stringValue
                    profileView.introduceLabel.text = userInfo["contents"].stringValue
                    do {
                        let imageData = try Data(contentsOf: URL(string: userInfo["profile_image"].stringValue)!)
                        profileView.profileImage.image = UIImage(data: imageData)
                    } catch {
                        profileView.profileImage.image = UIImage()
                    }
                    if userInfo["gender"].stringValue == "M" {
                        profileView.profileBorderImage.image = UIImage(named: "img_profile_line_m")
                        profileView.sexImage.image = UIImage(named: "ico_sex_m")
                        profileView.sexAgeView.layer.borderColor = self.colorManager.profileManSexAgeBorderColor.cgColor
                        profileView.ageLabel.textColor = self.colorManager.profileSexLabeltextColor
                    }
                    
                    self.view.addSubview(profileView)
                })
                
                
            default:
                print("default")
            }
            //responseCallback(data)
        })
        
//        bridge?.callHandler(handlerName: "$.callFromWeb", data: nil, responseCallback: { (data) in
//            print("Swift received response\(String(describing: data))")
//        })
    }
}


