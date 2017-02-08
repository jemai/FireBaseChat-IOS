//
//  AppDelegate.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //
        initApplication()
        //
        return true
    }
    // MARK: - Url functions
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        debugPrint("the url is \(url)")
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:  options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
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
    // MARK: - Initializers
    func initApplication(){
        initNavigationBar()
        initFireBase()
        startViewController()
        registerForRemoteNotif()
    }
    
    // MARK: - check session
    func startViewController() {
        //start the chat view controller if still logged in
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user : FIRUser?) in
            if user != nil {
                let mainNavigationController = UINavigationController(rootViewController: UsersListViewController())
                self.window?.rootViewController = mainNavigationController
            }else {
                //start the Login view controller if not logged
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController = LoginViewController()
            }
        })
    }
    
    func initNavigationBar(){
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Constants.AppBaseColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
    }
    // MARK: - Login logout functions
    func onSuccessLogin(){
        let mainNavigationController = UINavigationController(rootViewController: UsersListViewController())
        self.window?.rootViewController = mainNavigationController
        
    }
    //
    func registerForRemoteNotif()  {
        
    }
    //
    func logOut(){
        window?.rootViewController = LoginViewController()
    }
    // MARK: - FireBase init
    func initFireBase(){
        FIRApp.configure()
    }
}
