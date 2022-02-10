////
////  APIManager.swift
////  Babyhoney
////
////  Created by yeoboya_211221_03 on 2022/01/12.
////
//
import Foundation
import Alamofire
import SwiftyJSON
// TODO: - APIManager
class JoinApiManager: JoinApiService {
    
    var apiServiceProvider: ApiService?
    
    init(service: ApiService) {
        self.apiServiceProvider = service
        print("JoinApiManager init")
    }
    
    deinit {
        print("JoinApiManager deinit")
    }
    
    // 회원정보 얻어오기
    func getMembershipStatus(_ email: String, completion: ((JSON) -> Void)?) {
        self.apiServiceProvider?.requestApi(url: "http://babyhoney.kr/api/member/\(email)", method: .get, parameters: nil,
                                            completion: { data in
            let response = data as? DataResponse<Any, AFError>
            var result: JSON?
            
            switch (response?.result) {
            case .success(let res):
                print("========================회원 여부 확인 완료========================")
                result = JSON(res)
                print(result)
            case .failure(let err):
                print("🚫 Alamofire Request Error\nCode:\(err._code), Message: \(err.errorDescription!)")
            default:
                print("default")
            }
            completion!(result!)
        })
    }
    
    // 회원가입정보 보내기
    func postUserInfo(_ userInfo: JoinModel, completion: (()-> Void)?) {
        
        let imageData = userInfo.profileImg?.jpegData(compressionQuality: 1)!
        
        let parameters: [String: Any]? =  [
            "email" : userInfo.email as Any,
            "name" : userInfo.name as Any,
            "age" : userInfo.age as Any,
            "costs" : userInfo.costs as Any,
            "profile_img" : imageData as Any
        ]
        
        self.apiServiceProvider?.requestApiMultiPart(url: "http://babyhoney.kr/api/member", parameters: parameters, completion: { data in
            let response = data as? DataResponse<Any, AFError>
            
            switch (response?.result) {
            case .success(let res):
                print("========================회원가입 요청 완료 (\(res))========================")
                
            case .failure(let err):
                print("🚫 Alamofire Request Error\nCode:\(err._code), Message: \(err.errorDescription!)")
            default:
                print("default")
            }
        })
        
    }
    
    // 프로필 리스트 불러오기
    func getProfileList(_ email: String, completion: (() -> Void)?) {
        self.apiServiceProvider?.requestApi(url: "http://babyhoney.kr/api/member/list/\(email)", method: .get, parameters: nil, completion: {
            data in
                let response = data as? DataResponse<Any, AFError>
                
                switch (response?.result) {
                case .success(let res):
                    print("========================채팅 리스트 요청 성공========================")
                    print(res)
                    
                case .failure(let err):
                    print("🚫 Alamofire Request Error\nCode:\(err._code), Message: \(err.errorDescription!)")
                default:
                    print("default")
                }
        })
    }
    
}
