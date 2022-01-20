//
//  getRootVC.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/20.
//

import Foundation
import UIKit

func getRootViewController() -> UIViewController? {
    guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
        return nil
    }

    var topController = rootViewController

    while let newTopController = topController.presentedViewController {
        topController = newTopController
    }

    return topController
}
