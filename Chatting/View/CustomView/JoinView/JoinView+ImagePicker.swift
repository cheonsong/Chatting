//
//  JoinView+ImagePicker.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import UIKit
import SafariServices
import Photos

extension JoinView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 선택된 이미지 가져오기
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            addImageLabel.isHidden = true
            pictureView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            if let fileName = (asset.value(forKey: "filename")) as? String {
                print(fileName)
            }
        }
        
        // 이미지 피커 띄우기
        let vc = getRootViewController()
        vc?.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
    // 라이브러리에서 이미지 선택하기
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        getRootViewController()?.present(imagePicker, animated: false)
        
    }
    
    func openCamera(){
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        getRootViewController()?.present(imagePicker, animated: false, completion: nil)
    }
}
