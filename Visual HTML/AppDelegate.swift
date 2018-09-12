//
//  AppDelegate.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Constant.ScreenX = window?.screen.bounds.maxX
        Constant.ScreenY = window?.screen.bounds.maxY
        do{
            try! FileManager.default.createDirectory(atPath: Constant.MY_DIRECTORY, withIntermediateDirectories: true, attributes: nil)
            try! FileManager.default.createDirectory(atPath: NSHomeDirectory() + "/Documents/FTP/", withIntermediateDirectories: true, attributes: nil)
            print("Success")
        }
        catch let error as Error{
            print(error)
        }
        
        if !UserDefaults.standard.bool(forKey: Constant.IF_LAUCHED_STRING){
            UserDefaults.standard.set(true, forKey: Constant.IF_LAUCHED_STRING)
            var url = Constant.FTP.FTP_STORAGE_URL
            var array:Array<FTPManager> = []
            let dataWrite = try? JSONEncoder().encode(array)
            do {
                try? dataWrite?.write(to: URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL))
            } catch {
                print("保存到本地文件失败")
               
            }
            
        }else{
            if let dataRead = try? Data(contentsOf: URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL)) {
                let newArray = try? JSONDecoder().decode([FTPManager].self, from: dataRead)
            } else {
                var url = Constant.FTP.FTP_STORAGE_URL
                url.append("ftpList.txt")
                var array:Array<FTPManager> = []
                let dataWrite = try? JSONEncoder().encode(array)
                do {
                    try dataWrite?.write(to: URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL))
                } catch {
                    print("保存到本地文件失败")
                    
                }
            }
        }
        
        if launchOptions != nil{
            var vc = DocumentShareController()
            var nav = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
            vc.path = launchOptions![UIApplicationLaunchOptionsKey.url] as! URL
            vc.preview()
        }
        
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Visual_HTML")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var vc = DocumentShareController()
        
       // var nav = UINavigationController(rootViewController: vc)
        
        vc.view.frame.size.width = 200
        vc.view.frame.size.height = 500
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.white
        vc.path = url
        print(url.description)
         //  vc.preview()
       
    
        return true;
    }
    
  

}

