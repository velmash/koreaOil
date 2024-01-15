//
//  AppDelegate.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import NMapsMap
import FirebaseCore
import GoogleMobileAds
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        
        //애드몹
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //카카오내비 용
        KakaoSDK.initSDK(appKey: "185c06b1b0b9bdcb0c914bb7f18a193a")
        
        if defaults.string(forKey: UDOilType) == nil {
            defaults.setValue(OilType.gasolin.rawValue, forKey: UDOilType)
        }
        
        if defaults.string(forKey: UDRangeType) == nil {
            defaults.setValue(RangeType.oneK.rawValue, forKey: UDRangeType)
        }
        
        if defaults.string(forKey: UDNaviType) == nil {
            defaults.setValue(NaviType.naver.rawValue, forKey: UDNaviType)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

