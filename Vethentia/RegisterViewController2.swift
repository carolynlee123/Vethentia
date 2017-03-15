//
//  RegisterViewController2.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/21/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController2: UIViewController , NSURLSessionDelegate, UITextFieldDelegate { //NSURLSessionTaskDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var firstnameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var lastnameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var zipTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var streetTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    
    let defaults = NSUserDefaults.standardUserDefaults()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.titleView?.hidden = true
        let customFont = UIFont(name: "OpenSans-Regular", size: 13.0)
        navTitle.title = "Create Profile"
        navBar.barTintColor = UIColor.whiteColor()
        backButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)

        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        continueButton.setTitleColor(UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0), forState: .Normal)
        continueButton.backgroundColor = UIColor.whiteColor()
        continueButton.layer.cornerRadius = 5
        
        firstnameTF.delegate = self
        lastnameTF.delegate = self
        streetTF.delegate = self
        zipTF.delegate = self
        passwordTF.delegate = self
        
        firstnameTF.becomeFirstResponder()
      
        firstnameTF.autocorrectionType = UITextAutocorrectionType.No
        firstnameTF.placeholder = "First name"
        firstnameTF.title = "First name"
        firstnameTF.font = UIFont.init(name: "OpenSans", size: 17)
        firstnameTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        firstnameTF.tintColor = UIColor.whiteColor()
        firstnameTF.textColor = UIColor.whiteColor()
        firstnameTF.lineColor = UIColor.whiteColor()
        firstnameTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        firstnameTF.selectedLineColor = UIColor.whiteColor()
        firstnameTF.lineHeight = 0.5
        firstnameTF.selectedLineHeight = 1.5
        firstnameTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        firstnameTF.iconText = "\u{f2c0}"
        firstnameTF.iconColor = UIColor.lightGrayColor()
        firstnameTF.selectedIconColor = UIColor.whiteColor()
        firstnameTF.iconMarginBottom = 0.5

        lastnameTF.placeholder = "Last name"
        lastnameTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        lastnameTF.title = "Last name"
        lastnameTF.font = UIFont.init(name: "OpenSans", size: 17)
        lastnameTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        lastnameTF.tintColor = UIColor.whiteColor()
        lastnameTF.textColor = UIColor.whiteColor()
        lastnameTF.lineColor = UIColor.whiteColor()
        lastnameTF.selectedLineColor = UIColor.whiteColor()
        lastnameTF.lineHeight = 0.5
        lastnameTF.selectedLineHeight = 1.5
        lastnameTF.autocorrectionType = UITextAutocorrectionType.No
        lastnameTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        lastnameTF.iconText = "\u{f2c0}"
        lastnameTF.iconColor = UIColor.lightGrayColor()
        lastnameTF.selectedIconColor = UIColor.whiteColor()
        lastnameTF.iconMarginBottom = 0.5
        
        streetTF.placeholder = "Billing street number"
        streetTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        streetTF.title = "Street number"
        streetTF.font = UIFont.init(name: "OpenSans", size: 17)
        streetTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        streetTF.tintColor = UIColor.whiteColor()
        streetTF.textColor = UIColor.whiteColor()
        streetTF.lineColor = UIColor.whiteColor()
        streetTF.selectedLineColor = UIColor.whiteColor()
        streetTF.lineHeight = 0.5
        streetTF.selectedLineHeight = 1.5
        streetTF.autocorrectionType = UITextAutocorrectionType.No
        streetTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        streetTF.iconText = "\u{f015}"
        streetTF.iconColor = UIColor.lightGrayColor()
        streetTF.selectedIconColor = UIColor.whiteColor()
        streetTF.iconMarginBottom = 0.5
        
        zipTF.placeholder = "Billing zip code"
        zipTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        zipTF.title = "Postal code"
        zipTF.font = UIFont.init(name: "OpenSans", size: 17)
        zipTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        zipTF.tintColor = UIColor.whiteColor()
        zipTF.textColor = UIColor.whiteColor()
        zipTF.lineColor = UIColor.whiteColor()
        zipTF.selectedLineColor = UIColor.whiteColor()
        zipTF.lineHeight = 0.5
        zipTF.selectedLineHeight = 1.5
        zipTF.autocorrectionType = UITextAutocorrectionType.No
        zipTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        zipTF.iconText = "\u{f041}"
        zipTF.iconColor = UIColor.lightGrayColor()
        zipTF.selectedIconColor = UIColor.whiteColor()
        zipTF.iconMarginBottom = 0.5
        
        passwordTF.placeholder = "Password"
        passwordTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        passwordTF.title = "Password"
        passwordTF.font = UIFont.init(name: "OpenSans", size: 17)
        passwordTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        passwordTF.errorColor = UIColor.redColor()
        passwordTF.tintColor = UIColor.whiteColor()
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.lineColor = UIColor.whiteColor()
        passwordTF.selectedLineColor = UIColor.whiteColor()
        passwordTF.lineHeight = 0.5
        passwordTF.selectedLineHeight = 1.5
        passwordTF.autocorrectionType = UITextAutocorrectionType.No
        passwordTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        passwordTF.iconText = "\u{f023}"
        passwordTF.iconColor = UIColor.lightGrayColor()
        passwordTF.selectedIconColor = UIColor.whiteColor()
        passwordTF.iconMarginBottom = 0.5
        passwordTF.secureTextEntry = true
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareforsegue")
       // if (segue == "goto_reg44") {
            Variables.firstName = firstnameTF.text!
            Variables.lastName = lastnameTF.text!
            Variables.address = streetTF.text!
            Variables.postCode = zipTF.text!
            Variables.password = passwordTF.text!
            
            //--Save using NSUserDefaults--
            defaults.setValue(firstnameTF.text!, forKey: "MyFirstName")
            defaults.setValue(lastnameTF.text!, forKey: "MyLastName")
            defaults.setValue(streetTF.text!, forKey: "MyStreet")
            defaults.setValue(zipTF.text!, forKey: "MyZip")
            defaults.setValue(passwordTF.text!, forKey: "MyPassword")
            defaults.synchronize()
            print("defaults: \(defaults.stringForKey("MyFirstName"))")

        //}
        
    }

    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goback_reg", sender: sender)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        if (firstnameTF.text == "" || lastnameTF.text == "" || streetTF.text == "" || zipTF.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please enter information for all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if (!validatePasswordRegex(passwordTF.text!)) {
            let alert = UIAlertController(title: "Error", message: "Password must contain an uppercase letter, number, and special character!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier("goto_reg44", sender: sender)
        }
    }
    
    func validatePasswordRegex(text : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluateWithObject(text)
        //println("\(capitalresult)")
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluateWithObject(text)
        //println("\(numberresult)")
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluateWithObject(text)
        //println("\(specialresult)")
        
        return capitalresult || numberresult || specialresult
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
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
