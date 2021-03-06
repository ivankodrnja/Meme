//
//  AppDelegate.swift
//  Meme
//
//  Created by Ivan Kodrnja on 03/05/15.
//  Copyright (c) 2015-2021 Ivan Kodrnja. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // declare Meme object
    var memes = [Meme]()
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        /*
        // create a new window with the size of the current window and set it as our main window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // instantiate a new storyboard where we will create a new initial view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // this will be the new initial viewcontroller
        var targetViewController: UIViewController
        
        // TODO: if thre are images start
        // if there are no memes initial view controller will be Meme Editor (based on StoryboardID)
        if memes.count == 0 {
             targetViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditorViewController
        } else {
            // if there are memes the initial view controller will be UITabBarController (SentMemes)  (based on StoryboardID)
             targetViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SentMemes") as! UITabBarController
        }
        
        // set the newly created view controller as the window's root view controller
        self.window?.rootViewController = targetViewController
        // make the new wondow visible
        self.window?.makeKeyAndVisible()
        */
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

