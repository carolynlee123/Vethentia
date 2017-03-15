//
//  AppDelegate.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/20/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import CoreData
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var client: MSClient?
    var defaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("didfinishlaunching")
        
        //defaults.removeObjectForKey("MyDeviceToken")
        //defaults.removeObjectForKey("sessionID")
        //--Set Root View Controller--
        if (defaults.objectForKey("sessionID") != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewControllerWithIdentifier("navVC") as! NavigationViewController
            if let window = self.window {
                window.rootViewController = rootController
            }
        }

        //--Push Notification Setup--
        let notificationTypes : UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        print("Registered")
        //--Azure Integration---
        self.client = MSClient(applicationURLString:"Endpoint=sb://vethentiaservices.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=ykhwSlcjR3dSYdi6EijMmI+eOgFT15Vggg7cra8mmKY=", applicationKey:"AzureHubNotificationEndpoint")
        
        //--Stripe API--
        //Stripe.setDefaultPublishableKey("pk_test_WlsL3RzEV82GVmfFunmV93ja")
        STPPaymentConfiguration.sharedConfiguration().publishableKey = "pk_test_WlsL3RzEV82GVmfFunmV93ja"
        STPPaymentConfiguration.sharedConfiguration().appleMerchantIdentifier = "merchant.com.vethentia"
        
        return true
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register with error: \(error)");
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Got token data! \(deviceToken)")
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        //--Update device token on server if different on relaunch--
        if (defaults.objectForKey("MyDeviceToken") != nil && String(defaults.objectForKey("MyDeviceToken")) != deviceTokenString) {
            let url: NSURL = NSURL(string: "http://vethentia.azurewebsites.net/api/accounts/registerphonetoken/" + Variables.userID + "/" + deviceTokenString)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "PUT"
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    print("Device token sent successfully")
                }
                else {
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            })
            task.resume()
        }
        
        Variables.deviceToken = deviceTokenString
        print("deviceTokenString: \(deviceTokenString)")
        defaults.setValue(deviceTokenString, forKey: "MyDeviceToken")
        defaults.synchronize()
        
        //--Azure Notification Hub--
        let hub = SBNotificationHub(connectionString: HUBLISTENACCESS, notificationHubPath: HUBNAME)
        hub.registerNativeWithDeviceToken(deviceToken, tags:nil, completion: { (error) in
            if (error != nil) {
                print("Error registering for notification: \(error)")
            }
            else {
                print("registered successfully")
            }
        })
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        print("Recived: \(userInfo)")
        
        let apsNotification = userInfo["aps"] as? NSDictionary
        let apsString  = apsNotification?["alert"] as? String
        //--Parse APNS token request---
        let tid = userInfo["tid"] //as? NSString
        print("app delegate tid : \(tid)")
        let amount = userInfo["amount"] //as? NSString
        let countryCode = userInfo["countryCode"] //as? NSString
        let currencyCode = userInfo["currencyCode"] //as? NSString
        let time = userInfo["ttime"] //as? NSString
        let shippingInfo = userInfo["shippingInfo"] //as? NSString
        let merchantName = userInfo["merchantName"] 
        let merchantID = userInfo["merchantIdentifier"]
        let publicKey = userInfo["publicKey"]
        defaults.setValue(tid, forKey: "MyTID")
        defaults.setValue(amount, forKey: "MyAmount")
        defaults.setValue(countryCode, forKey: "MyCountryCode")
        defaults.setValue(currencyCode, forKey: "MyCurrencyCode")
        defaults.setValue(time, forKey:"MyTime")
        defaults.setValue(merchantName, forKey: "MyMerchantName")
        defaults.setValue(merchantID, forKey: "MyMerchantID")
        defaults.setValue(shippingInfo, forKey: "MyShippingInfo")
        defaults.setValue(publicKey, forKey: "MyPublicKey")
        
        var currentViewController = self.window?.rootViewController
        while currentViewController?.presentedViewController != nil {
            currentViewController = currentViewController?.presentedViewController
        }
        if application.applicationState == .Inactive || application.applicationState == .Background {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as? PaymentViewController
            paymentVC?.navigationController?.navigationBarHidden = false
            currentViewController?.presentViewController(paymentVC!, animated: true) {}
        }
        
        let alert = UIAlertController(title: "Alert", message: apsString, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { _ in
            print("OK")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { _ in
            print("Cancel")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    
    }

    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state                                                                                                                                                                                                                    .
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        //--Check for session--

        if (defaults.objectForKey("sessionID") != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewControllerWithIdentifier("navVC") as!NavigationViewController
            if let window = self.window {
                window.rootViewController = rootController
            }
        }

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("applicationWillTerminate")
        
        self.saveContext()
    }
    
    //--Saving application state--
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }


    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Vethentia.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    /*lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Vethentia")
        container.loadPersistentStoresWithCompletionHandler({ (storeDescription, error) in
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
    }*/
    
   
}

