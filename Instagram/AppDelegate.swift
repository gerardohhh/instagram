//
//  AppDelegate.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/26/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "instaGreat"
                configuration.clientKey = "sdncvreilcnx,iejofm2e"
                configuration.server = "https://instagr8.herokuapp.com/parse"
            })
        )
        
        // Persist user
        if PFUser.current() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedNavController = storyboard.instantiateViewController(withIdentifier: "FeedNavController")
            window?.rootViewController = feedNavController
        }
        
        // Log user out
        NotificationCenter.default.addObserver(forName: NSNotification.Name("logoutNotification"), object: nil, queue: OperationQueue.main) { (Notification) in
            // Take user to logout screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginViewController
        }
        
        // Finish Post
        NotificationCenter.default.addObserver(forName: NSNotification.Name("sentPostNotification"), object: nil, queue: OperationQueue.main) { (Notification) in
            // Take user to logout screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedNavController = storyboard.instantiateViewController(withIdentifier: "FeedNavController")
            self.window?.rootViewController = feedNavController
        }
        
        // Remove back button titles
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

