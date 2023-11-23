//
//  LocalNotifications.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.11.2023.
//

import UserNotifications

class LocalNotifications {
    static let shared = LocalNotifications()
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Success")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func contentNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Image app"
        content.body = "Check your favorite image"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("water.wav"))
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let id = UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
