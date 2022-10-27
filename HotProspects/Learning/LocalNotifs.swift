//
//  LocalNotifs.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI
import UserNotifications

struct LocalNotifs: View {
    var body: some View {
        VStack {
            
            // requesting authorization to show alerts. Notifications can take a variety of forms, but the most common thing to do is ask for permission to show alerts, badges, and sounds – that doesn’t mean we need to use all of them at the same time, but by asking permission up front means we can be selective later on
            Button("Request Permission") {
                // When we tell iOS what kinds of notifications we want, it will show a prompt to the user so they have the final say on what our app can do. When they make their choice, a closure we provide will get called and tell us whether the request was successful or not.
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Divider()
            
            /*
             If the user grants permission, then we’re all clear to start scheduling notifications. Even though notifications might seem simple, Apple breaks them down into three parts to give it maximum flexibility:

                 The content is what should be shown, and can be a title, subtitle, sound, image, and so on.
                 The trigger determines when the notification should be shown, and can be a number of seconds from now, a date and time in the future, or a location.
                 The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.

             */
            
            // When you’re just learning notifications the easiest trigger type to use is UNTimeIntervalNotificationTrigger, which lets us request a notification to be shown in a certain number of seconds from now.

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default

                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

struct LocalNotifs_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotifs()
    }
}
