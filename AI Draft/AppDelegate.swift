//
//  AppDelegate.swift
//  AI Draft
//
//  Created by Suren Poghosyan on 01.07.23.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        // Create the window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // Check if the user is already signed in
        if Auth.auth().currentUser != nil {
            // User is signed in, show the NewViewController
            let newViewController = NewViewController()
            window?.rootViewController = newViewController
        } else {
            // User is not signed in, show the ViewController
            let viewController = ViewController()
            window?.rootViewController = viewController
        }

        GIDSignIn.sharedInstance.restorePreviousSignIn{ [self]user, error in
            if error != nil || user == nil {
                let viewController = ViewController()
                self.window?.rootViewController = viewController
            } else {
                let newViewController = NewViewController()
                self.window?.rootViewController = newViewController
            }
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
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }

        // Handle other custom URL types.

        // If not handled by this app, return false.
        return false
    }

}
