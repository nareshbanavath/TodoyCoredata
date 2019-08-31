//
//  AppDelegate.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 30/07/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            //let realm = Realm()
            _ = try Realm()
        }catch
        {
          print("Error Initialising the Realm\(error)")
        }
        return true
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack

    //lazy variables are loaded when they called it means when i call persistentContainer variable at that time only it loads in memory and returns me container
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        //here container is like DB with name 'TodoyCoredata'
//        let container = NSPersistentContainer(name: "TodoyCoredata")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

//    func saveContext () {
//        //context is like stagingArea(stores temparary changes) where we can perform creat ,update ,delete ,undo ,redo options but they won't store in persistent container until unless we call save() on top on context object
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

