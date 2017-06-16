//
//  AppDelegate.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (isAuthorized, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            if isAuthorized {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CloudKitManager.subscribeToNotifications(recordType: Contact.kRecordType)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ContactController.fetchNewContacts()
    }
}

