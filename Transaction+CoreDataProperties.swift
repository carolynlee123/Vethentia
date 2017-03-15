//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Carolyn Lee on 12/18/16.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction");
    }

    @NSManaged public var amount: String?
    @NSManaged public var merchantName: String?
    @NSManaged public var date: String?

}
