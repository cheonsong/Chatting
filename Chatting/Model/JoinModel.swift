//
//  JoinModel.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/19.
//

import Foundation
import UIKit

class JoinModel {
    var email: String?
    var name: String?
    var profileImg: UIImage?
    var age: String?
    var costs: String?
    var gender: String?
    
    var year: String? {
        didSet{
            age = currentAge()
        }
    }
    
    // 모든 정보가 작성됐을 경우에만 가입버튼 활성화
    func validation() -> Bool{
        
        if email != nil, name != nil, profileImg != nil, age != nil, costs != nil, gender != nil {
            return true
        } else { return false }
    }
    
    func currentAge() -> String {
        let year = year?.trimmingCharacters(in: .letters)
        
        return String(compareDate(prevTime: year!) / (60*60*24*365) + 1)
    }
    
}
