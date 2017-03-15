//
//  RegisterViewController3.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/31/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit

class RegisterViewController3: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navTitle: UINavigationItem!
   
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.becomeFirstResponder()
        
        self.navigationController?.navigationItem.titleView?.hidden = true
        navTitle.title = ""
        navBar.barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        backButton.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        
        continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        continueButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        continueButton.layer.cornerRadius = 5
        firstNameTF.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        firstNameTF.borderStyle = UITextBorderStyle.None
        firstNameTF.autocorrectionType = UITextAutocorrectionType.No
        firstNameTF.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        lastNameTF.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        lastNameTF.borderStyle = UITextBorderStyle.None
        lastNameTF.autocorrectionType = UITextAutocorrectionType.No
        lastNameTF.tintColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
    }

    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goback_reg2", sender: sender)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("goto_reg4", sender: sender)
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
