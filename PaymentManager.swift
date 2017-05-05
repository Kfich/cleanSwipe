//
//  AuthManager.swift
//  Envested
//
//  Created by Lin Gang Xuan on 30/12/15.
//  Copyright © 2015 Envested. All rights reserved.
//

import Foundation

class PaymentManager: NSObject {
    
    static let sharedManager = PaymentManager()
    
    var fullName: String = ""
    var cardNumber: String = ""
    var securityCode: String = ""
    var expDate: String = ""
    var zip: String = ""
    var address: String = ""
    var userHasDefaultPayment: Bool = false

    func reset() {
        fullName = ""
        cardNumber = ""
        securityCode = ""
        expDate = ""
        zip = ""
        address = ""
        userHasDefaultPayment = false
        
    }
    
    // =========== Figure out how to validate date information =============

    
    func paymentValidation() -> (success: Bool, errorMessage: String?) {
        if fullName.characters.count == 0 && cardNumber.characters.count == 0 && securityCode.characters.count == 0 && expDate.characters.count == 0 && zip.characters.count == 0 && address.characters.count == 0{
            return (false,"Please enter your payment information")
        }
        
        guard fullName.characters.count > 0 else {
            return (false,"Please enter your first name")
        }
        guard cardNumber.characters.count > 0 else {
            return (false,"Please enter your card information")
        }
        guard isValidCardNumber(cardNumber) == true else {
            return (false,"Please enter a valid card number")
        }
        guard address.characters.count > 0 else {
            return (false,"Please enter a valid billing address")
        }
        guard securityCode.characters.count > 0 else {
            return (false,"Please enter security code")
        }
        guard securityCode.characters.count >= 3 else {
            return (false,"Please enter a valid security code")
        }
        guard expDate.characters.count > 0 else {
            return (false,"Please enter an expiration date")
        }
        guard expDate.characters.count == 7 else {
            return (false,"Please enter a valid expiration date")
        }
        guard isValidZip(zip) == true else {
            return (false,"Please enter a valid zip code")
        }
    
        return (true,nil)
    }
    
    func isValidCardNumber(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let cardRegEx = "[0-9]{16}"
        
        let cardTest = NSPredicate(format:"SELF MATCHES %@", cardRegEx)
        return cardTest.evaluate(with: testStr)
    }
    
    func isValidZip(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let zipRegEx = "[0-9]{5}"
        
        let zipTest = NSPredicate(format:"SELF MATCHES %@", zipRegEx)
        return zipTest.evaluate(with: testStr)
    }
    
    // Convert card to dictionary
    
    func getPaymentDictionary() -> AnyObject {
        let dict = [
            "card_number": cardNumber,
            "expiration": expDate,
            "security": securityCode
        ]

        return dict as AnyObject
    }
    
    func getDescriptionDictionary() -> AnyObject {
        let dict = [
            "cardholder_name": fullName,
            "billing": address,
            "zip": zip
        ]

        return dict as AnyObject
    }

    
    // Device storage
    
    func rememberPaymentInfo(_ payment: NSDictionary){
        
        let paymentDict = payment
        UDWrapper.setDictionary("default_payment", value: paymentDict)
    }
    
    func retrieveDefaultPayment() -> NSDictionary{
        
        var payment = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "default_payment") != nil{
            
            payment = userInfo.value(forKey: "default_payment") as! NSDictionary
            print("Payment: \(payment)")
            
            PaymentManager.sharedManager.cardNumber = payment.value(forKey: "card_number") as! String
            PaymentManager.sharedManager.expDate = payment.value(forKey: "expiration") as! String
            
            PaymentManager.sharedManager.securityCode = payment.value(forKey: "security") as! String
            
            // Set hasPayment to true
            
            PaymentManager.sharedManager.userHasDefaultPayment = true
            
            _ = retrievePaymentDescription()
            
            
        }else{
            print("There was no default payment")
            PaymentManager.sharedManager.userHasDefaultPayment = false
        }
        return payment
    }
    
    
    func rememberPaymentDescription(_ description: NSDictionary){
        let descriptionDict = description
        UDWrapper.setDictionary("paymet_description", value: descriptionDict)
    }
    
    func retrievePaymentDescription() -> NSDictionary {
        
        let descriptionDict = UDWrapper.getDictionary("paymet_description")
        return descriptionDict!
    }
    
    
}










