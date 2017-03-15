//
//  SettingsViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 12/7/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import Stripe

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPPaymentCardTextFieldDelegate {

    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    let sectionTitles = ["Payment Methods", "Account Info", "General", ""]
    let generalSettings = ["Notifications"]
    let accountSettings = [Variables.email, Variables.formattedNumber, "Edit Email or Phone"]
    var creditCardTF = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 19.0)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)

        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        //self.view.addGestureRecognizer(tap)
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.cellLayoutMarginsFollowReadableWidth = false
        settingsTableView.sectionHeaderHeight = 60
        settingsTableView.tableFooterView = UIView()
        //settingsTableView.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        
        creditCardTF.delegate = self
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, height: 50))
        let title = UILabel()
        title.text = sectionTitles[section]
        title.font = UIFont(name: "OpenSans", size: 17)!
        title.textColor = UIColor.init(red: 170/256, green: 170/256, blue: 170/256, alpha: 1.0)
        title.textAlignment = NSTextAlignment.Center
        title.backgroundColor = UIColor.init(red: 245/256, green: 245/256, blue: 245/256, alpha: 1.0)
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsMake(5.0, 25.0, 5.0, 25.0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        //--Credit card textfield
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                creditCardTF = STPPaymentCardTextField(frame: CGRectMake(25, 10, cell.contentView.frame.width - 50, cell.contentView.frame.height - 20))
                cell.contentView.addSubview(creditCardTF)

            }
            else {
                let label = UILabel(frame: CGRectMake(25, 15, 25, 25))
                label.font = UIFont(name: "FontAwesome", size: 25)
                label.text = "\u{f196}"
                cell.accessoryView = label
                cell.accessoryView?.frame.origin.x = -(100)
                cell.textLabel?.text = "Add Credit Card"
                cell.textLabel!.font = UIFont(name: "OpenSans", size: 17)!
                cell.textLabel?.textColor = UIColor.init(red: 170/256, green: 170/256, blue: 170/256, alpha: 1.0)
            }
            
        }
        
        if (indexPath.section == 1) {
            cell.textLabel?.text = accountSettings[indexPath.row]
            cell.textLabel!.font = UIFont(name: "OpenSans", size: 17)!
            cell.textLabel?.textAlignment = .Left
            if (indexPath.row == 2) {
                cell.textLabel?.textColor = UIColor.init(red: 170/256, green: 170/256, blue: 170/256, alpha: 1.0)
            }
        }
        
        //--General
        if (indexPath.section == 2) {
            cell.textLabel?.text = generalSettings[0]
            cell.textLabel!.font = UIFont(name: "OpenSans", size: 17)!
            cell.textLabel?.textAlignment = .Left
        }
        
        //--Bottom section, sign out
        if (indexPath.section == 3) {
            cell.textLabel?.text = "Sign Out"
            cell.textLabel!.font = UIFont(name: "OpenSans", size: 17)!
            cell.textLabel?.textColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            cell.textLabel?.textAlignment = .Center
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return Variables.numPaymentMethods + 2
        }
        else if (section == 1) {
            return accountSettings.count
        }
        else if (section == 2){
            return generalSettings.count;
        }
        else {
            return 1
        }
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 3) {
            let alert = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sign out", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
