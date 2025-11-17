import Foundation
import UIKit
import SwiftUI
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared =
    UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication,supportedInterfaceOrientationsFor window:UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.shared
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
  }


extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("d07350e3-47d5-4f56-9cf9-aa84ffb441f6")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
                })
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        return true
    }
    


    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
