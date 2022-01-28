//
//  JoinView+PickerView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import UIKit
import RxCocoa

extension JoinView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (pickerView) {
        case yearPickerView:
            return year.count
        case monthPickerView:
            return month.count
        case dayPickerView:
            return day.count
        default:
            print("Wrong pickerview")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerView) {
        case yearPickerView:
            return year[row] + "년"
        case monthPickerView:
            return month[row] + "월"
        case dayPickerView:
            return day[row] + "일"
        default:
            print("Wrong pickerview")
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (pickerView) {
        case yearPickerView:
            yearLabel.text = year[row] + "년"
            yearLabel.textColor = colorManager.color17
        case monthPickerView:
            monthLabel.text = month[row] + "월"
            monthLabel.textColor = colorManager.color17
        case dayPickerView:
            dayLabel.text = day[row] + "일"
            dayLabel.textColor = colorManager.color17
        default:
            print("Wrong pickerview")
        }
    }
    
    func setPickerView() {
        setYearPickerView()
        setMonthPickerView()
        setDayPickerView()
        setToolBar()
    }
    
    func setToolBar() {
        // 피커뷰 툴바추가
        pickerToolbar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50)
        pickerToolbar.barStyle = .default
        //pickerToolbar.isTranslucent = true  // 툴바가 반투명인지 여부 (true-반투명, false-투명)
        pickerToolbar.backgroundColor = .gray
        pickerToolbar.sizeToFit()   // 서브뷰만큼 툴바 크기를 맞춤
        // 피커뷰 툴바에 확인/취소 버튼추가
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        pickerToolbar.setItems([space , btnDone], animated: true)   // 버튼추가
        pickerToolbar.isUserInteractionEnabled = true   // 사용자 클릭 이벤트 전달
    }
    
    func setYearPickerView() {
        yearPickerView.backgroundColor = .gray
        yearPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
    }
    
    func setMonthPickerView() {
        monthPickerView.backgroundColor = .gray
        monthPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
    }
    
    func setDayPickerView() {
        dayPickerView.backgroundColor = .gray
        dayPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
    }
    
    // 피커뷰 > 확인 클릭
    @objc func onPickDone() {
        yearPickerView.removeFromSuperview()
        monthPickerView.removeFromSuperview()
        dayPickerView.removeFromSuperview()

        pickerToolbar.removeFromSuperview()
    }
    
    
}
