//
//  AddCardViewController.swift
//  Vethentia
//
//  Created by Carolyn Lee on 12/6/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import UIKit
import Stripe

class AddCardViewController: STPAddCardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: STPErrorBlock) {
        /*self.submitTokenToBackend(token, completion: { (error: Error?) in
            if let error = error {
                completion(error)
            } else {
                self.dismiss(animated: true, completion: {
                    self.showReceiptPage()
                    completion(nil)
                })
            }
        })*/
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
