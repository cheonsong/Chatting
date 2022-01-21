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
    }

    func getMembershipStatus(_ email: String, completion: ((Bool) -> Void)?) {
        self.apiServiceProvider?.requestApi(url: "http://babyhoney.kr/api/member/\(email)", method: .get, parameters: nil,
                                            completion: { data in
            let response = data as? DataResponse<Any, AFError>
            var result: Bool?
            
            switch (response?.result) {
            case .success(let res):
                print("========================회원 여부 확인 완료========================")
                result = JSON(res)["is_member"].rawValue as! Bool
            case .failure(let err):
                print("🚫 Alamofire Request Error\nCode:\(err._code), Message: \(err.errorDescription!)")
            default:
                print("default")
            }
            completion!(result!)
        })
    }
    
//    // 비제이에게 사연 보내기
//    func postStoryToBJ(_ story: String ,completion: (() -> Void)?) {
//
//        let parameters: [String: Any]? = [ "send_mem_gender": "M",
//                                           "send_mem_no": 4521,
//                                           "send_chat_name": "천송",
//                                           "send_mem_photo": "",
//                                           "story_conts": story,
//                                           "bj_id": "cheonsong"]
//
//        self.apiServiceProvider?.requestApi(url: "http://babyhoney.kr/api/story", method: .post, parameters: parameters, completion: { data in
//            // data는 Any 타입이므로 이를 사용하기 위해 다운캐스팅 진행
//            let response = data as? DataResponse<Any, AFError>
//
//            switch (response?.result) {
//            case .success:
//                print("POST 성공")
//            case .failure(let err):
//                print("🚫 Alamofire Request Error\nCode:\(err._code), Message: \(err.errorDescription!)")
//            default:
//                print("default")
//            }
//
//        })
//    }
    
}
