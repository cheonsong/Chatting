//
//  ChatView+gesture.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension JoinView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let name = gestureRecognizer.name
        
        switch(name) {
        case "EndEditing":
            self.view?.endEditing(true)
            
        case "ImagePick":
            // Input: imagePickButtonClicked
            // 라이브러리에서 이미지 선택하기
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "앨범에서 선택하기", style: .default, handler: { _ in
                self.openLibrary()
            }))
            
            alert.addAction(UIAlertAction(title: "카메라로 촬영하기", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            getRootViewController()?.present(alert, animated: false, completion: nil)
            
        case "Year":
            self.view?.addSubview(self.yearPickerView)
            self.view?.addSubview(self.pickerToolbar)
            
        case "Month":
            self.view?.addSubview(self.monthPickerView)
            self.view?.addSubview(self.pickerToolbar)
            
        case "Day":
            self.view?.addSubview(self.dayPickerView)
            self.view?.addSubview(self.pickerToolbar)
            
        default:
            print("default")
        }
        return true
    }
    

}
