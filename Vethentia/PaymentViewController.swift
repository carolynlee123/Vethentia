//
//  PaymentViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 12/16/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import PassKit
import Stripe
import CoreData

class PaymentViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var purchaseButton: UIButton!
    let supportedPaymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
    //let merchantID = "merchant.com.vethentia"  //""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        //self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        self.title = "Code Check"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "OpenSans-Bold", size: 18.0)!]
        purchaseButton.hidden = !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(supportedPaymentNetworks)
        purchaseButton.layer.cornerRadius = 5.0
        //purchaseButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        
        
        /*let item = PKPaymentSummaryItem(label: defaults.stringForKey("MyMerchantName")!, amount: NSDecimalNumber(double: Double(defaults.stringForKey("MyAmount")!)!))
        let request = PKPaymentRequest()
        request.merchantIdentifier = defaults.stringForKey("MyMerchantIdentifier")!
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = .Capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [item]
        
        if Stripe.canSubmitPaymentRequest(request) {
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController.delegate = self
            applePayController.view.frame.size.height = self.view.frame.size.height
            applePayController.view.frame.size.width = self.view.frame.size.height
            presentViewController(applePayController, animated: true, completion: nil)
        }
        else {
            //default to Stripe's PaymentKit Form
       }*/
    }
    @IBAction func purchaseButtonPressed(sender: UIButton) {
        let item = PKPaymentSummaryItem(label: defaults.stringForKey("MyMerchantName")!, amount: NSDecimalNumber(double: Double(defaults.stringForKey("MyAmount")!)!))
        let request = PKPaymentRequest()
        request.merchantIdentifier = defaults.stringForKey("MyMerchantIdentifier")!
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = .Capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [item]
        
        if Stripe.canSubmitPaymentRequest(request) {
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController.delegate = self
            //applePayController.view.frame.size.height = self.view.frame.size.height
            //applePayController.view.frame.size.width = self.view.frame.size.height
            presentViewController(applePayController, animated: true, completion: nil)
            print("presenting vc")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PaymentViewController : PKPaymentAuthorizationViewControllerDelegate {
    //--Handles user authorization to complete purchase
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        
        Stripe.setDefaultPublishableKey("pk_test_WlsL3RzEV82GVmfFunmV93ja")

        Stripe.createTokenWithPayment(payment) { token, error in
            if let token = token {
                //let url = NSURL(string: "http://192.168.0.19:5000/pay")  // Replace with computers local IP Address!
                print("tokenID: \(token.tokenId)")
                let tid = self.defaults.stringForKey("MyTID")
                print("tid: \(tid)")
                let url = NSURL(string: "https://vethentia.azurewebsites.net/api/payments/tokenresponse/8/" + tid! + "/" + token.tokenId + "/0")
                print(url)

                let request = NSMutableURLRequest(URL: url!)
                //request.HTTPMethod = "POST"
                request.HTTPMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                let amount = self.defaults.stringForKey("MyAmount")?.stringByReplacingOccurrencesOfString(".", withString: "")
                //let amount = "1000"
                /*let body = ["stripeToken": token.tokenId, "amount": NSDecimalNumber(string: amount), "description": "Test Purchase from V-Server"]*/
                let body:NSMutableDictionary = NSMutableDictionary()
                body.setValue(8, forKey: "msgId")
                body.setValue(tid, forKey: "tid")
                body.setValue(token.tokenId, forKey: "token")
                body.setValue(0, forKey: "status")

                let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
                request.HTTPBody = jsonData
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                    if (error != nil) {
                        print("Failed sending payment request.")
                        completion(PKPaymentAuthorizationStatus.Failure)
                    } else {
                        print("Sucessfully sent payment request")
                        Variables.totalTransactions += 1;
          
                        completion(PKPaymentAuthorizationStatus.Success)
                    }
                }
                completion(.Success)
            } else {
                print("token failed")
                completion(.Failure)
            }
        }
        
        //--HARDCODE
        //completion(PKPaymentAuthorizationStatus.Success)
    }
    
    //--Called when payment request completes--
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        
        //--CoreData, temp hardcode
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Transaction", inManagedObjectContext: managedContext)
        let transaction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        transaction.setValue(defaults.stringForKey("MyAmount"), forKey:"amount")
        transaction.setValue(defaults.stringForKey("MyMerchantName"), forKey: "merchantName")
        //transaction.setValue(12, forKey: "date")
        print(transaction)
        
        do {
            try managedContext.save()
            } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewControllerWithIdentifier("navVC") as? NavigationViewController
        //self.navigationController?.pushViewController(mainVC!, animated: true)
        self.presentViewController(navVC!, animated: true) {}
    }
    
}


