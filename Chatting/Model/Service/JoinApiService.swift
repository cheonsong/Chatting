//
//  StoryApiService.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/12.
//

import Foundation
import Alamofire

protocol JoinApiService {

//    // 사연 리스트 GET
//    func getStoryList(_ page: Int, completion: ((Int, Int, [Story]) ->Void)?)
//
//    // 사연 보내기 POST
//    func postStoryToBJ(_ story: String, completion: (() -> Void)?)
    
    // 회원가입 여부 확인 GET
    func getMembershipStatus(_ email: String, completion: ((Bool)-> Void)?)
    
    // 회원가입 POST
    func postUserInfo(_ userInfo: JoinModel, completion: (()-> Void)?)
    
    // 채팅방리스트 요청 GET
    func getChattingList(_ email: String, completion: (()->Void)?)
}
