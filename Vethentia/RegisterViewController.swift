//
//  RegisterViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/20/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import MessageUI
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, UITextFieldDelegate, NSURLSessionDelegate {

    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon! //UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0);
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //emailTF.delegate = self
        emailTF.becomeFirstResponder()
        navTitle.title = "Enter email"
        navBar.barTintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        backButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 13.0)!], forState: .Normal)

        emailTF.placeholder = "Email"
        emailTF.font = UIFont.init(name: "OpenSans", size: 17)
        emailTF.placeholderFont = UIFont.init(name: "OpenSans", size: 17)
        emailTF.title = "Email address"
        emailTF.selectedTitleColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        emailTF.errorColor = UIColor.redColor()
        emailTF.tintColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)//UIColor.whiteColor()
        emailTF.textColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        emailTF.placeholderColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        emailTF.lineColor = UIColor.init(red: 239/256, green: 242/256, blue: 242/256, alpha: 1.0)
        emailTF.selectedLineColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        emailTF.lineHeight = 0.5
        emailTF.selectedLineHeight = 1.5
        emailTF.iconFont = UIFont(name: "FontAwesome", size: 15)
        emailTF.iconText = "\u{f003}"
        emailTF.iconColor = UIColor.lightGrayColor()
        emailTF.selectedIconColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)//UIColor.whiteColor()
        emailTF.iconMarginBottom = 0.0
        emailTF.delegate = self
        emailTF.autocorrectionType = UITextAutocorrectionType.No
        
        continueButton.setTitleColor(UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0), forState: .Normal)
        continueButton.backgroundColor = UIColor.init(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0)
        continueButton.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        // For line on bottom of text field
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.borderWidth = width
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Variables.email = emailTF.text!
        defaults.setValue(emailTF.text!, forKey: "MyEmail")
        defaults.synchronize()
    }


    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goto_home2", sender: sender)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        if (!self.validateEmail(self.emailTF.text!)) {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        self.existingUser() { (exists) -> () in
            if (exists == true) {
                let alert = UIAlertController(title: "Error", message: "Email address already exists!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                }
                print("test")

            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("goto_reg2", sender: sender)
                }
            }
        }
    }
    
    func validateEmail(inputEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(inputEmail)
    }
    
    func existingUser(completion: (existing: Bool)->()) {
        print("existingUser")
        let requestURL: NSURL = NSURL(string: "https://vethentia.azurewebsites.net/api/accounts/users")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        print("initiated session")
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    print("download successful")
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        print("json: \(json)")
                        for user in json as! [Dictionary<String, AnyObject>] {
                            if (self.emailTF.text! == user["Email"] as! String) {
                                print("found existing user!")
                                dispatch_async(dispatch_get_main_queue()) {
                                    let alert = UIAlertController(title: "Error", message: "Email address is already in use!", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                                }
                                completion(existing: true)
                                return
                            }
                         }
                        completion(existing: false)
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
                else {
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                    completion(existing: false)
                }
            }
            else {
                print("Unwrapping NSHTTPResponse failed")
                completion(existing: false)
            }
            
        })
        task.resume()
    }

    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if(text.characters.count < 3 || !text.containsString("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //emailTF.resignFirstResponder()
        self.view.endEditing(true)
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
