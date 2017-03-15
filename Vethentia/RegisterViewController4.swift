//
//  RegisterViewController4.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/31/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftSpinner

class RegisterViewController4: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var phoneTF: PhoneNumberTextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var agreeLabel: UILabel!
    
    let phoneNumberKit = PhoneNumberKit()
    var previousNumber: Int?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    class TextField: UITextField {
        let padding = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0);
        
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Variables.deivcetolen: \(Variables.deviceToken)")
        
        phoneTF.becomeFirstResponder()
        phoneTF.delegate = self
        
        backButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)
        
        navTitle.title = "Phone Verification"

        navBar.barTintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //backButton.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        backButton.tintColor = UIColor.whiteColor()
        
        //sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //sendButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
    
        sendButton.layer.cornerRadius = 5
        phoneTF.attributedPlaceholder = NSAttributedString(string:"Phone Number", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        phoneTF.borderStyle = UITextBorderStyle.None
        phoneTF.autocorrectionType = UITextAutocorrectionType.No
        phoneTF.tintColor = UIColor.whiteColor()//UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        phoneTF.textColor = UIColor.whiteColor()
        phoneTF.keyboardType = UIKeyboardType.NumberPad
        
        let phoneIcon = UIImage(named: "Phone-50.png")
        let phoneView = UIImageView(frame: CGRect(x: 0, y: 0, width: phoneIcon!.size.width * 0.4, height: phoneIcon!.size.height * 0.4))
        phoneView.image = phoneIcon
        let lview: UIView = UIView()
        lview.frame = CGRectMake(0, 0, 25, 20)
        lview.backgroundColor = UIColor.clearColor()
        lview.addSubview(phoneView)
        phoneTF.leftView = lview
        phoneTF.leftViewMode = UITextFieldViewMode.Always
        
        var agreeText = NSMutableAttributedString()
        agreeText = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and Privacy Policy", attributes: [NSFontAttributeName:UIFont(name: "OpenSans", size: 12.0)!])
        agreeText.addAttribute(NSFontAttributeName, value: UIFont(name:"OpenSans-Bold", size: 12.0)!, range: NSRange(location:41,length:18))
        agreeText.addAttribute(NSFontAttributeName, value: UIFont(name:"OpenSans-Bold", size: 12.0)!, range: NSRange(location:64,length:14))
        agreeLabel.attributedText = agreeText
        
    }
    
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(1.0)
        //border.borderColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0).CGColor
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: phoneTF.frame.size.height  - width, width: phoneTF.frame.size.width, height: phoneTF.frame.size.height)
        border.borderWidth = width
        phoneTF.layer.addSublayer(border)
        phoneTF.layer.masksToBounds = true
        
    }

    @IBAction func sendButtonPressed(sender: UIButton) {
        do {
            let phoneNumber = try PhoneNumber(rawNumber: phoneTF.text!, region: "US")
            Variables.formattedNumber = phoneNumber.toInternational()
            let myRange = Range<String.Index>(start: Variables.formattedNumber.startIndex, end: Variables.formattedNumber.endIndex)
            Variables.formattedNumber = Variables.formattedNumber.stringByReplacingOccurrencesOfString(
                "[^\\d+]", withString: "", options: .RegularExpressionSearch,
                range: myRange)
            print(Variables.formattedNumber)
            defaults.setValue(Variables.formattedNumber, forKey: "MyPhoneNumber")
            defaults.synchronize()
        }
        catch {
            print("Generic parser error")
        }
        SwiftSpinner.show("Sending Code")
        //self.performSegueWithIdentifier("goto_verify", sender: sender)
        self.postToServer() { (success) -> () in
            if (success) {
                /*dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("goto_verify", sender: sender)
                }*/
                print("register success")
                self.getID() { (done) -> () in
                    if (done) {
                        self.sendDeviceToken() { (sent) -> () in
                            if (sent) {
                                print("Device token sent")
                                dispatch_async(dispatch_get_main_queue()) {
                                    SwiftSpinner.hide()
                                    self.performSegueWithIdentifier("goto_verify", sender: sender)
                                }
                            }
                            else {
                                print("unable to send device token")
                            }
                        }
                    }
                    else {
                        print("failed getting user id")
                    }
                }
                
            }
        }
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goback_reg2", sender: sender)
    }
    
    func postToServer(completion: (finished: Bool)->()) {
        let url: NSURL = NSURL(string: "https://vethentia.azurewebsites.net/api/accounts/register")!
        let request = NSMutableURLRequest(URL: url)
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(15, forKey: "msgId")
        para.setValue(Variables.email, forKey: "emailAddress")
        para.setValue(Variables.firstName, forKey: "firstName")
        para.setValue(Variables.lastName, forKey: "lastName")
        para.setValue(Variables.formattedNumber, forKey: "phoneNumber")
        para.setValue(Variables.postCode, forKey: "billingZipCode")
        para.setValue(Variables.address, forKey: "billingStreetNumber")
        para.setValue(Variables.password, forKey: "password")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(para, options: [])
        //print(jsonData)
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        print(jsonString)
        request.HTTPBody = jsonData//try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        print("created nsurl session")
        
        let session = NSURLSession.sharedSession()
        // post to server request
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("success")
                    completion(finished: true)
                }
                else {
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                    completion(finished: false)
                }
            }
            else {
                print("Unwrapping NSHTTPResponse failed")
                completion(finished: false)
            }
        })
        task.resume()
    }
    
    func sendDeviceToken(completion: (sent: Bool)->()) {
        let url: NSURL = NSURL(string: "http://vethentia.azurewebsites.net/api/accounts/registerphonetoken/" + Variables.userID + "/" + Variables.deviceToken)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "PUT"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("Device token sent successfully")
                completion(sent: true)
            }
            else {
                print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                completion(sent: false)
            }
        })
        task.resume()
    }
    
    func getID(completion: (found: Bool)->()) {
        print("in getID")
        let requestURL: NSURL = NSURL(string: "https://vethentia.azurewebsites.net/api/accounts/users")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("download successful")
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    print("json: \(json)")
                    for user in json as! [Dictionary<String, AnyObject>] {
                        if Variables.formattedNumber == user["PhoneNumber"] as? String {
                            
                            Variables.userID = user["Id"] as! String
                            print("User id: \(Variables.userID)")
                            completion(found: true)
                            return
                        }
                    }
                    completion(found: false)
                } catch {
                    print("Error with Json: \(error)")
                }
            }
            else {
                print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
            }
        })
        task.resume()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
