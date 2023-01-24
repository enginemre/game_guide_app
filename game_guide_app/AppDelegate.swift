//
//  AppDelegate.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit
import CoreData
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Kingfisher's Cache
          let cache = ImageCache.default

          // Constrain Memory Cache to 10 MB
          cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10

          // Constrain Disk Cache to 100 MB
          cache.diskStorage.config.sizeLimit = 1024 * 1024 * 100
        
        // Customizing UI Navigation bar
        UINavigationBar.appearance().backgroundColor = UIColor(named: "AccentColor")
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Sk-Modernist-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "arrow-back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "arrow-back")
        
        UITabBar.appearance().tintColor = UIColor(named: "MainColor")
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
  
        CoreDataManager(game: "game_guide_app")
        
        
        let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) {(accepted, error) in
                if !accepted {
                    print("Notification access denied")
                }
            }
        
        
        return true
    }

   

}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        
        completionHandler( [.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
