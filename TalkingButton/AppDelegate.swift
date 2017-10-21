//
//  AppDelegate.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //録音
        print("Simulator path",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        AudioRecorderManager.shared.setup()
        
        
        //PageControlの色、背景色の設定
        let pageBar = UIPageControl.appearance()
        pageBar.backgroundColor = UIColor.white
        pageBar.pageIndicatorTintColor = UIColor(red: 210/255, green: 210/255, blue: 205/255, alpha: 1.0)
        pageBar.currentPageIndicatorTintColor = UIColor(red: 132/255, green: 185/255, blue: 203/255, alpha: 1)
        

        //初回起動の設定
        let launchedBefore = UserDefaults.standard.bool(forKey: "first")
        
        if launchedBefore {
        
        } else
        {
        //初回起動時、TutrialViewControllerを起動
            UserDefaults.standard.set(true, forKey: "first")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let initiaView = mainStoryBoard.instantiateViewController(withIdentifier: "TurialVC")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initiaView
            self.window?.makeKeyAndVisible()
        }
        
        
        //Admob設定
        GADMobileAds.configure(withApplicationID: "ca-app-pub-********~********")
        FIRApp.configure()
        
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

