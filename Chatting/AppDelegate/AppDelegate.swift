//
//  AppDelegate.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit
import KakaoSDKCommon
import NaverThirdPartyLogin
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let NativeAppKey = "d0f1d1a5e6f51b689a902c3d53036644"
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("----------------------kakaoSDK.initSDK()----------------------")
        KakaoSDK.initSDK(appKey: NativeAppKey)
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        return true
    }
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available (iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

