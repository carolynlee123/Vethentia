//
//  CodeCheckViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 1/8/17.
//  Copyright © 2017 Carolyn Lee. All rights reserved.
//

import UIKit

class CodeCheckViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter Code"
        codeTF.becomeFirstResponder()
        codeTF.autocorrectionType = UITextAutocorrectionType.No
        //codeTF.keyboardType = UIKeyboardType.NumberPad
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 19.0)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "OpenSans", size: 17.0)!], forState: .Normal)
        verifyButton.layer.cornerRadius = 5
    }

    @IBAction func verifyButtonPressed(sender: UIButton) {
        self.codeIndication() { (success) -> () in
            if (success) {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Sucesss", message: "Code Matches", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                }
                
            }
            else {
                print("code check failed")
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Error", message: "Invalid Code", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.view.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
                }
                
            }
        }
    }
 
    func codeIndication(completion: (success: Bool)->()) {
        let url: NSURL = NSURL(string: "http://vethentia.azurewebsites.net/api/payments/codeindication")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(6, forKey: "msgId")
        para.setValue(Variables.email, forKey: "vid")
        para.setValue(Variables.deviceToken, forKey: "deviceToken")
        para.setValue(codeTF.text, forKey: "rxCode")
        para.setValue(Variables.formattedNumber, forKey: "phoneNumber")
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(para, options: [])
        //print(jsonData)
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        print(jsonString)
        urlRequest.HTTPBody = jsonData//try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        // post to server request
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("success")
                    completion(success: true)
                }
                else {
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                    completion(success:  false)
                }
            }
            else {
                print("Unwrapping NSHTTPResponse failed")
                completion(success: false)
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
