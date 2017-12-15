//
//  AppDelegate.swift
//  LAMer
//
//  Created by Ludovico Loreti on 07/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

let primaryColor = UIColor(red: 107/255, green: 0/255, blue: 0/255, alpha: 1)
let secondaryColor = UIColor(red: 230/255, green: 175/255, blue: 0/255, alpha: 1)
let dbRef = Database.database().reference(fromURL: "https://lamer-171d6.firebaseio.com/")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// init Firebase!!!!!!! FIRE FIREEEEEEE
		FirebaseApp.configure()
		Database.database().isPersistenceEnabled = true

		
		// [[FBSDKApplicationDelegate sharedInstance] application:application
		// didFinishLaunchingWithOptions:launchOptions];
		
		// trasformo il codice sovrastante copiato da developers.facebook per il corretto funzionamento dell'sdk in swift 4
		
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		
		//        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
		//            openURL:url
		//            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
		//            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
		//        ];
		//        // Add any custom logic here.
		//        return handled;
		
		// trasformo il codice sovrastante copiato da developers.facebook per il corretto funzionamento dell'sdk in swift 4
		
		let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
		
		return handled
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
		AuthenticationManager.sharedInstance.needsAuthentication = true
		print("\n\n \t Foreground!\n\(AuthenticationManager.sharedInstance.needsAuthentication)\n")
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
}

