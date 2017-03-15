//
//  Variables.swift
//  Vethentia
//
//  Created by Carolyn Lee on 11/13/16.
//  Copyright © 2016 Carolyn Lee. All rights reserved.
//

import Foundation

struct Variables {
    static var firstName: String = ""
    static var lastName: String = ""
    static var email: String = ""
    static var postCode: String = ""
    static var address: String = ""
    static var password: String = ""
    //static var phone: String = ""
    static var formattedNumber: String = ""
    static var uiPhoneNumber: String = ""
    static var userID: String = ""
    static var verificationCode: Int = 0
    static var deviceToken: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    static var numPaymentMethods = 0
    static var totalTransactions = 0
}

