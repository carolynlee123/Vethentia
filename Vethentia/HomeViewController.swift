//
//  ViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 10/20/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        registerButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        loginButton.backgroundColor = UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //loginButton.backgroundColor = UIColor.white
        //loginButton.setTitleColor(UIColor.init(red: 12/255, green: 148/255, blue: 69/255, alpha: 1.0), for: .normal)
        loginButton.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
        
       /* let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.init(red: 202/255.0, green: 228.0/255, blue: 241.0/255, alpha: 1.0).CGColor, UIColor.init(red: 0/255.0, green: 87.0/255, blue: 138.0/255, alpha: 1.0).CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)*/
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "shattered_.png")?.drawInRect(self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("goto_login", sender: sender)
    }
    
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("goto_register", sender: sender)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

