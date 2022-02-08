//
//  StoryApiService.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/12.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol JoinApiService: AnyObject {
    
    // 회원가입 여부 확인 GET
    func getMembershipStatus(_ email: String, completion: ((JSON)-> Void)?)
    
    // 회원가입 POST
    func postUserInfo(_ userInfo: JoinModel, completion: (()-> Void)?)
    
    // 프로필리스트 요청 GET
    func getProfileList(_ email: String, completion: (()->Void)?)
    
}
