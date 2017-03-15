//
//  LoginViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/21/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var touchIDLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    let context : LAContext = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        //touchIDButton.setImage(UIImage(named: "touchid.png"), forState: .Normal)
        //touchIDButton.imageView?.contentMode = UIViewContentMode.Center
        
        usernameTF.delegate = self
        passwordTF.delegate = self
        usernameTF.becomeFirstResponder()
        usernameTF.attributedPlaceholder = NSAttributedString(string:"Email address", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        passwordTF.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        usernameTF.borderStyle = UITextBorderStyle.None
        passwordTF.borderStyle = UITextBorderStyle.None
        usernameTF.autocorrectionType = UITextAutocorrectionType.No
        passwordTF.autocorrectionType = UITextAutocorrectionType.No
        passwordTF.secureTextEntry = true
        passwordTF.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        usernameTF.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 5
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        forgotButton.backgroundColor = UIColor.clearColor()
        forgotButton.setTitleColor(UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0), forState: .Normal)
        
        let lview: UIView = UIView()
        let lview2: UIView = UIView()
        lview.frame = CGRectMake(0, 0, 27, 20)
        lview2.frame = CGRectMake(0, 0, 27, 20)
        lview.backgroundColor = UIColor.clearColor()
        lview2.backgroundColor = UIColor.clearColor()
        let emailIcon = UIImage(named: "Message-50.png")
        let emailView = UIImageView(frame: CGRect(x: 0, y: 0, width: emailIcon!.size.width * 0.4, height: emailIcon!.size.height * 0.4))
        emailView.image = emailIcon
        lview.addSubview(emailView)
        usernameTF.leftView = lview
        usernameTF.leftViewMode = UITextFieldViewMode.Always
        
        let passwordIcon = UIImage(named: "Password-50.png")
        let passwordView = UIImageView(frame: CGRect(x: 0, y: 0, width: passwordIcon!.size.width * 0.4, height: passwordIcon!.size.height * 0.4))
        passwordView.image = passwordIcon
        lview2.addSubview(passwordView)
        passwordTF.leftView = lview2
        passwordTF.leftViewMode = UITextFieldViewMode.Always
        
        //orLabel.text = "------------------------ or -----------------"
        
        
        // navigation bar
        self.navigationItem.leftBarButtonItem = backButton
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "shattered_.png")?.drawInRect(self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)

    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: usernameTF.frame.size.height  - width, width: usernameTF.frame.size.width, height: usernameTF.frame.size.height)
        border.borderWidth = width
        usernameTF.layer.addSublayer(border)
        usernameTF.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0).CGColor
        border2.frame = CGRect(x: 0, y: passwordTF.frame.size.height - width , width: passwordTF.frame.size.width, height: passwordTF.frame.size.height)
        border2.borderWidth = width2
        passwordTF.layer.addSublayer(border2)
        passwordTF.layer.masksToBounds = true
    }

    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goto_home", sender: sender)
    }
    

    @IBAction func forgotButtonPressed(sender: UIButton) {
        //-------------------------------------
        //--TODO: forgot password functionality
        //-------------------------------------
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.userLogin() { (success) -> () in
            if (success) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("goto_mainFromLogin", sender: sender)
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Error", message: "Invalid username/password combination.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
 
            }
        }
    }
    
    @IBAction func touchIDButtonPressed(sender: UIButton) {
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:nil) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID", reply: { (success : Bool, error : NSError? ) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.performSegueWithIdentifier("goto_mainFromLogin", sender: self)
                    }
                    if error != nil {
                        var message : NSString
                        var showAlert : Bool
                        switch(error!.code) {
                        case LAError.AuthenticationFailed.rawValue:
                            message = "There was a problem verifying your identity."
                            showAlert = true
                            break;
                        case LAError.UserCancel.rawValue:
                            message = "You pressed cancel."
                            showAlert = true
                            break;
                        case LAError.UserFallback.rawValue:
                            message = "You pressed password."
                            showAlert = true
                            break;
                        default:
                            showAlert = true
                            message = "Touch ID may not be configured."
                            break;
                        }
                        
                        let alertView = UIAlertController(title: "Error", message: message as String, preferredStyle:.Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertView.addAction(okAction)
                        alertView.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                        if showAlert {
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                        
                    }
                })
                
            })
        }
        else {
            let alertView = UIAlertController(title: "Error",
                                              message: "Touch ID not available." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            alertView.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
            self.presentViewController(alertView, animated: true, completion: nil)
        }

    }
   
    func userLogin(completion: (matches: Bool)->()) {
        let requestURL: NSURL = NSURL(string: "https://microsoft-apiappb021a068b6a04e4eaeef35509b030ef0.azurewebsites.net/api/accounts/users")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    print("json: \(json)")
                    for user in json as! [Dictionary<String, AnyObject>] {
                        if self.usernameTF.text! == user["Email"] as? String {
                            if (self.passwordTF.text! == user["Password"] as? String) {
                                completion(matches: true)
                                return
                            }
                            else {
                                completion(matches: false)
                                return
                            }
                        }
                        else {
                            completion(matches: false)
                            return;
                        }
                    }
                    completion(matches: false)
                    return;
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
