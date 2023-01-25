//
//  LocalNotificationManager.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
    
    static private var notification : LocalNotificationContent?
    
    static private func requestPermission() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options : [.alert,.badge,.alert]){ granted, error in
            if(granted == true && error == nil){
                
            }
        }
        
    }
    
    static private func addNotification(title : String, body : String) -> Void {
        notification =  LocalNotificationContent(id: UUID().uuidString, title: title, body: body)
    }
    
    static private func scheduleNotifications(_ duration: Int){
        if let notification = notification {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            let date = Date().addingTimeInterval(Double(duration))
            let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request){ error in
                guard error == nil else {return}
                print("Notification id : \(notification.id)")
            }
        }
        notification = nil
        
    }
    
    static func cancel(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func setNotification(_ duration : Int,title : String, body : String){
        requestPermission()
        addNotification(title: title, body: body)
        scheduleNotifications(duration)
    }
        
}


struct LocalNotificationContent{
    var id : String
    var title : String
    var body : String
}
