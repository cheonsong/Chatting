//
//  WebViewVC+Naver.swift
//  Chatting
//
//  Created by cheonsong on 2022/02/03.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

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
            loginInstance?.requestAccessTokenWithRefreshToken()
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { [weak self] response in
            guard let self = self else { return }
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let email = object["email"] as? String else { return }
            
            self.naverEmail = email
            
            self.apiManager.getMembershipStatus(self.naverEmail, completion: { result in
                self.memInfo.age = result["mem_info"]["age"].stringValue
                self.memInfo.email = result["mem_info"]["email"].stringValue
                self.memInfo.contents = result["mem_info"]["contents"].stringValue
                self.memInfo.name = result["mem_info"]["name"].stringValue
                self.memInfo.gender = result["mem_info"]["gender"].stringValue
                self.memInfo.profileImage = result["mem_info"]["profile_image"].stringValue
                
                result["is_member"].rawValue as! Bool ? self.goToProfileList() : self.goToJoinView()
            })
            
            self.loginInstance?.requestDeleteToken()
        }
    }
}
