//
//  DateComparison.swift
//  Babyhoney
//
//  Created by yeoboya_211221_03 on 2022/01/12.
//

import Foundation

// Post된 시간과 현재 시간을 비교하는 함수

func compareDate(prevTime time: String) -> Int {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let currentDate = Date()
    let prevDate = formatter.date(from: time)
    
    let tis = Int(currentDate.timeIntervalSince(prevDate!))
    return tis - 32400
}
