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
        
        let vc = getRootViewController()
        vc?.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
    
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        
        let viewController = getRootViewController()
        imagePicker.modalPresentationStyle = .fullScreen
        viewController?.present(imagePicker, animated: false)
        
    }
    
//    func openCamera(){
//        picker.sourceType = .camera
//        self.present(picker, animated: false, completion: nil)
//    }
}
