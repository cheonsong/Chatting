//
//  APIServiceProvider.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/12.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIServiceProvider: ApiService {
    
    init() {
        print("ApiServiceProvicer init")
    }
    
    deinit {
        print("ApiServiceProvicer deinit")
    }
    
    // Alamofire을 사용한 Api 요청
    func requestApi(url: String, method: HTTPMethod, parameters: [String : Any]?, completion: ((_ response: Any?) ->Void)?) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        if (method == .post) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters as Any, options: [])
            } catch {
                print("🚫 http Body Error")
            }
        }
        AF.request(request).responseJSON(completionHandler: completion!)
        
    }
    
    func requestApiMultiPart(url: String, parameters: [String : Any]?, completion: ((_ response: Any?) ->Void)?){
        let url = url
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        let image = parameters!["profile_img"] as? Data
        
        let param: Parameters = [
            "email" : parameters!["email"] as Any,
            "name" : parameters!["name"] as Any,
            "age" : parameters!["age"] as Any,
            "costs" : parameters!["costs"] as Any
        ]
        
        
        AF.upload(multipartFormData: { multiPart in
            for (k, v) in param {
                if let temp = v as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: k)
                }
            }
            multiPart.append(image!, withName: "profile_img", fileName: "name.png", mimeType: "image/jpeg")
        }, to: url, headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: completion!)
    }
}

