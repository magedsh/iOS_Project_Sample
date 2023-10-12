//
//  AppDelegate.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//

import UIKit
//import IQKeyboardManager
import MOLH
import Pushy
import AudioToolbox
import UserNotifications
import Alamofire
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate/*, WXApiDelegate*/ ,MOLHResetable, BMKGeneralDelegate ,BMKLocationAuthDelegate/*,UNUserNotificationCenterDelegate*/{
    
    
//    static  var chatWithCurrentUserId = 0
//    static var chatFromUserId = 0
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window?.overrideUserInterfaceStyle  = .light
        
        FirebaseApp.configure()
        
        MOLH.shared.activate(true)
        print ("getIsLogin \(UserData.getIsLogin())")
        
        let langStr = Locale.current.languageCode ?? ""
        
        print ("langStr \(langStr)")
        
        if langStr == "en"{
            
            UserData.saveMobileLanguage(lang: langStr)
            
        }else if  langStr == "ar" {
            
            UserData.saveMobileLanguage(lang: "ara")
            
        }else if langStr == "zh"{
            
            UserData.saveMobileLanguage(lang: "zh")
            
        }else {
            
            UserData.saveMobileLanguage(lang: "en")
            
        }
        
        if UserData.getIsFirstLaunch() {
            
            MOLH.setLanguageTo(langStr)
            UserData.setIsFirstLaunch(isLogin: false)
            
        }else {
            
        }
     
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        window = UIWindow(frame: UIScreen.main.bounds)
        return true
    }
    
    
  
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("userInfouserInfo \(userInfo)")
        
        sendNotification(not_id: "123", title: "asdasd", body: " vvvvv")
        
        return UIBackgroundFetchResult.newData
        
    }
      
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    
 
    
    
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
