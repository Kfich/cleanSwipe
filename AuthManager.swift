//
//  AuthManager.swift
//  Envested
//
//  Created by Lin Gang Xuan on 30/12/15.
//  Copyright © 2015 Envested. All rights reserved.
//

import Foundation

class AuthManager: NSObject {
    
    // Shared Instance
    
    static let sharedManager = AuthManager()
    
    // Properties
    // ==========================
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var phone: String = ""
    var selectedDorm: String = ""
    var roomNumber: String = ""
    var deviceToken: String = ""
    
    var segueString : String = ""
    
    var isVerifiedForUpdateSettings = false
    
    // Custom Methods
    // ==========================
    
    func reset() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        confirmPassword = ""
        phone = ""
        selectedDorm = ""
        roomNumber = ""
        isVerifiedForUpdateSettings = false
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@miami.edu"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidEmpEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@cleanswipe.co"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func forgotPasswordValidation() -> (success: Bool, errorMessage: String?) {
        guard email.characters.count > 0 else { return (false,"Please enter your email") }
        guard isValidEmail(email) else { return (false,"Please enter a valid email") }
        
        return (true,nil)
    }
    
    func registerValidationPhaseOne() -> (success: Bool, errorMessage: String?) {
        if firstName.characters.count == 0 && lastName.characters.count == 0 && email.characters.count == 0 && password.characters.count == 0 && confirmPassword.characters.count == 0 {
            return (false,"Please enter your registration details")
        }
        
        guard firstName.characters.count > 0 else {
            return (false,"Please enter your first name")
        }
        guard lastName.characters.count > 0 else {
            return (false,"Please enter your last name")
        }
        guard email.characters.count > 0 else {
            return (false,"Please enter your email")
        }
        guard isValidEmail(email) else {
            return (false,"Please enter a valid email")
        }
        guard password.characters.count > 0 else {
            return (false,"Please enter your desired password")
        }
        guard password.characters.count >= 6 else {
            return (false,"Password must be minimum 6 characters")
        }
        guard confirmPassword.characters.count > 0 else {
            return (false,"Please confirm your password")
        }
        guard confirmPassword.characters.count >= 6 else {
            return (false,"Password must be minimum 6 characters")
        }
        
        guard confirmPassword ==  password else {
            return (false,"Please make sure the passwords match")
        }

        return (true,nil)
    }
    
    func registerValidationPhaseTwo() -> (success: Bool, errorMessage: String?) {
        if selectedDorm.characters.count == 0 && roomNumber.characters.count == 0 && phone.characters.count == 0{
            return (false,"Please enter your registration details")
        }
        
        guard selectedDorm.characters.count > 0 else {
            return (false,"Please select")
        }
        guard phone.characters.count > 0 else {
            return (false,"Please enter your last name")
        }
        guard roomNumber.characters.count > 0 else {
            return (false,"Please enter your room number")
        }
        
        return (true,nil)
    }
    
    func loginValidation() -> (success: Bool, errorMessage: String?) {
        
        guard email.characters.count > 0 else { return (false,"Please enter your email") }
        guard isValidEmail(email) else { return (false,"Please enter a valid email") }
        
        guard password.characters.count > 0 else { return (false,"Please enter your password") }
        guard password.characters.count >= 6 else { return (false,"Password must be minimum 6 characters") }
        
        return (true,nil)
    }
    
    override var description: String {
        return "First name: \(firstName) \n Last Name: \(lastName) \n Email: \(email) \n Password: \(password)"
    }
    
    // Device storage 

    func rememberLastEmail(_ credentials: NSDictionary){
        
        let userDict = credentials
        UDWrapper.setDictionary("login_email", value: userDict)
    }
    
    func retrieveLastEmail() -> NSDictionary {
        
        let userDict = UDWrapper.getDictionary("login_email")
        return userDict!
    }
    
    
    func rememberUserCredentials(_ credentials: NSDictionary){
        
        let userDict = credentials
        UDWrapper.setDictionary("auth_credentials", value: userDict)
    }
    
    func retrieveUserCredentials() -> NSDictionary {
        
        let userDict = UDWrapper.getDictionary("auth_credentials")
        return userDict!
    }
    
    // Employee credentials
    
    func rememberEmpCredentials(_ credentials: NSDictionary){
        
        let userDict = credentials
        UDWrapper.setDictionary("emp_credentials", value: userDict)
    }
    
    func retrieveEmpCredentials() -> NSDictionary {
        
        let userDict = UDWrapper.getDictionary("emp_credentials")
        return userDict!
    }
    
    
    
    
    
}






