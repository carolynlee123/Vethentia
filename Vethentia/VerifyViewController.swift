//
//  VerifyViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 11/13/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftSpinner

class VerifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        tf1.becomeFirstResponder()
        navBar.barTintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        backButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        //gradient.colors = [UIColor.init(red: 202/255.0, green: 228.0/255, blue: 241.0/255, alpha: 1.0).CGColor, UIColor.init(red: 0/255.0, green: 87.0/255, blue: 138.0/255, alpha: 1.0).CGColor]
        gradient.colors = [UIColor.init(red: 164/255.0, green: 230.0/255, blue: 102.0/255, alpha: 1.0).CGColor, UIColor.init(red: 49/255.0, green: 185.0/255, blue: 110.0/255, alpha: 1.0).CGColor]

        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        verifyButton.setTitleColor(UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0), forState: .Normal)
        verifyButton.backgroundColor = UIColor.whiteColor()
        //verifyButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        verifyButton.layer.cornerRadius = 5
        
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        tf1.addTarget(self, action: #selector(VerifyViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        tf2.addTarget(self, action: #selector(VerifyViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        tf3.addTarget(self, action: #selector(VerifyViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        tf4.addTarget(self, action: #selector(VerifyViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        tf1.layer.cornerRadius = 5.0
        tf1.layer.borderWidth = 1.5
        tf2.layer.cornerRadius = 5.0
        tf2.layer.borderWidth = 1.5
        tf3.layer.cornerRadius = 5.0
        tf3.layer.borderWidth = 1.5
        tf4.layer.cornerRadius = 5.0
        tf4.layer.borderWidth = 1.5
        
        tf1.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        tf2.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        tf3.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        tf4.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        
        tf1.keyboardType = UIKeyboardType.NumberPad
        tf2.keyboardType = UIKeyboardType.NumberPad
        tf3.keyboardType = UIKeyboardType.NumberPad
        tf4.keyboardType = UIKeyboardType.NumberPad
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let s1: NSString = tf1.text!
        let s2: NSString = tf2.text!
        let s3: NSString = tf3.text!
        let s4: NSString = tf4.text!
        if (textField == tf1) {
            let ns1: NSString = s1.stringByReplacingCharactersInRange(range, withString: string)
            return ns1.length <= maxLength
        }
        else if (textField == tf2) {
            let ns2: NSString = s2.stringByReplacingCharactersInRange(range, withString: string)
            return ns2.length <= maxLength
        }
        else if (textField == tf3) {
            let ns3: NSString = s3.stringByReplacingCharactersInRange(range, withString: string)
            return ns3.length <= maxLength
        }
        else {
            let ns4: NSString = s4.stringByReplacingCharactersInRange(range, withString: string)
            return ns4.length <= maxLength
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        if (textField == tf1) {
            tf2.becomeFirstResponder()
        }
        if (textField == tf2) {
            tf3.becomeFirstResponder()
        }
        if (textField == tf3) {
            tf4.becomeFirstResponder()
        }
    }
    
     @IBAction func verifyButtonPressed(sender: UIButton) {
        SwiftSpinner.showWithDuration(3.0, title: "Creating Account", animated: true)
        self.getID() { (idSuccess) -> () in
            if (idSuccess) {
                print("found id")
                self.verifyUser() { (verifySuccess) -> () in
                    if (verifySuccess) {
                        print("yay")
                        //--Store session ID--
                        self.defaults.setValue(Variables.formattedNumber, forKey: "sessionID")
                        self.defaults.synchronize()
                        dispatch_async(dispatch_get_main_queue()) {
                            //self.showActivityIndicator(self.view)
                            self.performSegueWithIdentifier("goto_main", sender: sender)
                        }
                    }
                    else {
                        let alert = UIAlertController(title: "Error", message: "Incorrect code, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        dispatch_async(dispatch_get_main_queue()) {
                            alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        return
                    }
               }
            }
        }
        //self.performSegueWithIdentifier("goto_main", sender: sender)
        
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goback_verify", sender: sender)
    }
    
    @IBAction func resendButtonPressed(sender: UIButton) {
        
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
    
    func verifyUser(completion: (verified: Bool)->()) {
        let inputCode = tf1.text! + tf2.text! + tf3.text! + tf4.text!
        let requestURL: NSURL = NSURL(string: "https://vethentia.azurewebsites.net/api/accounts/confirmphone/" + Variables.userID + "/" + inputCode)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.HTTPMethod = "PUT"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("User Verified")
                completion(verified: true)
            }
            else {
                print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                completion(verified: false)
            }
        })
        task.resume()
    }
    
    func sendDeviceToken(completion: (sent: Bool)->()) {
        let url: NSURL = NSURL(string: "http://vethentia.azurewebsites.net/api/accounts/registerphonetoken/" + Variables.userID + "/" + Variables.deviceToken)!
        print("in device token\(Variables.deviceToken)")
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
    
    func showActivityIndicator(uiView: UIView) {
        let blurView: UIView = UIView()
        blurView.center = uiView.center
        blurView.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.init(red: 68, green: 68, blue: 68, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
                                    loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        blurView.addSubview(loadingView)
        self.view.addSubview(loadingView)
        print("in function")
        actInd.startAnimating()
        print("animation")
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
