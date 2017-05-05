//
//  PatientClass.swift
//  BinaryConversion
//
//  Created by Kevin Fich on 2/23/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation

public class Person{
    
    var personType : String = ""
    var fullName : String = ""
    var SSN : String = ""
    var email : String = ""
    var birthday : String = ""
    
    init() {}
    
    init(fullName full:String, lastName last:String, socialSecurity ssn:String, email personEmail:String, birthday personBirthday: String){
        
        fullName = full
        SSN       = ssn
        email = personEmail
        birthday = personBirthday
        
    }
    
    
    func getName()->String{
        return fullName
    }
    
    func setName(name : String){
        
        fullName = name;
    }

    func getEmail()->String{
        return email
    }
    
    func setEmail(personEmail : String){
        
        email = personEmail

    }
    
    
    func getBirthday()->String{
        return birthday
    }
    
    func setPatientBirthday(date : String){
        
        birthday = date
    }
    
    
}









