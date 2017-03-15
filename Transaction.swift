//
//  Transaction.swift
//  Vethentia
//
//  Created by Carolyn Lee on 12/18/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import Foundation
import CoreData

class Transaction: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    @NSManaged var amount: String?
    @NSManaged var merchantName: String?
}
