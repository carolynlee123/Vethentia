//
//  MainViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 11/15/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var codeButton: UIBarButtonItem!

    var transactions = [NSManagedObject]()
    var selectedItem = NSManagedObject?()
    var managedContext : NSManagedObjectContext?
    
    var count = 0
    var total = 1000
    //let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transactions"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
        settingsButton.tintColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        settingsButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)
        codeButton.tintColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        codeButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        fetchDataAndRefreshTable()
        
        activityTableView.delegate = self
        activityTableView.dataSource = self
        
        //performSegueWithIdentifier("goto_payment", sender: self)
    }
    
    func fetchDataAndRefreshTable() {
        let fetchRequest = NSFetchRequest(entityName: "Transaction")
        do {
            // retrieve the data
            transactions = try managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            print("reloading tableview")
            // reload the table
            activityTableView.reloadData()
        } catch {
            Swift.print(error)
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(transactions.count)
        return transactions.count
        //return total
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell", forIndexPath: indexPath) as UITableViewCell
        if (cell.subviews.count != 0) {
            for view in cell.subviews {
                view.removeFromSuperview()
            }
        }
        let item = transactions[indexPath.row]
        let merchantName = String(item.valueForKey("merchantName")!)
        
        cell.separatorInset = UIEdgeInsetsMake(5.0, 25.0, 5.0, 25.0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        let label = UILabel.init(frame: CGRectMake(20, 10, 40, 40))
        label.textColor = UIColor.whiteColor()
        label.text = String(merchantName.characters.first!)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        label.textAlignment = .Center
        label.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        label.layer.cornerRadius = label.frame.size.height / 2.0
        label.clipsToBounds = true
        cell.addSubview(label)
        
        let merchantLabel = UILabel.init(frame: CGRectMake(85, 10, 150, cell.frame.size.height - 20))
        merchantLabel.text = String(item.valueForKey("merchantName")!)
        merchantLabel.font = UIFont.init(name: "HelvetivaNeue", size: 16)
        cell.addSubview(merchantLabel)
        
        let amountLabel = UILabel.init(frame: CGRectMake(cell.frame.size.width - 100, 10, 65, cell.frame.size.height - 20))
        amountLabel.text = "$" + String(item.valueForKey("amount")!)
        amountLabel.font = UIFont.init(name: "HelvetivaNeue", size: 16)
        cell.addSubview(amountLabel)
        cell.textLabel?.text = String(item.valueForKey("amount"))
        return cell
    }
    
    
    //--Deletion--
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // remove the deleted item from the model
            /*let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDelegate.managedObjectContext
            context.deleteObject(transactions[indexPath.row] )
            transactions.removeAtIndex(indexPath.row)
            do {
                try context.save()
            } catch _ {
            }*/
                
            // remove the deleted item from the `UITableView`
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            total = total - 1
            tableView.reloadData()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func sendPushNotification(completion: (sent: Bool)->()) {
        let url: NSURL = NSURL(string: "https://microsoft-apiappb021a068b6a04e4eaeef35509b030ef0.azurewebsites.net/api/accounts/sendnotification")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("e37c8c71-6f2e-41f5-8375-7fbbca04d559", forKey: "Id")
        para.setValue("", forKey: "ToUser")
        para.setValue("Hello World!", forKey: "Message")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(para, options: [])
        //print("jsondata: \(jsonData)")
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        print("jsonString: \(jsonString)")
        urlRequest.HTTPBody = jsonData//try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("Notification sent")
                completion(sent: true)
            }
            else {
                print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                completion(sent: false)
            }
        })
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


  
}
