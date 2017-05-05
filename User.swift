//
//  User.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import Firebase

public class User{
    
    var username : String = ""
    var password : String = ""
    var userId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var email : String = ""
    var building : String = ""
    var dormRoom : String = ""
    var mobileNumber : String = ""
    
    init() {}
    
    init(firstName first:String, lastName last:String, email emailAddress:String, username uName:String, password pass:String){
        
        firstName = first
        lastName  = last
        email = emailAddress
        username = uName
        password = pass
        
    }
    
    init(snapshot: FDataSnapshot) {
        userId = snapshot.key
        fullName = snapshot.value["name"] as! String
        username = snapshot.value["username"] as! String
        email = snapshot.value["email"] as! String
        building = snapshot.value["dorm"] as! String
        dormRoom = snapshot.value["room_number"] as! String
        mobileNumber = snapshot.value["mobile_number"] as! String
        
        //printUser()
    }


    func toAnyObject() -> AnyObject {
        return [
            "name": getName(),
            "username": username,
            "uid": userId
        ]
    }
    
    func getName()->String{
        return firstName + " " + lastName
    }
    
    func setName(first : String, last: String){
        
        firstName = first
        lastName = last
    }
    
    func getEmail()->String{
        return email
    }
    
    func setEmail(personEmail : String){
        
        email = personEmail
        
    }
    
    func getUserId()->String{
        return userId
    }
    
    func setUserId(newId : String){
        
        userId = newId
    }
    
    func getUsername()->String{
        return username
    }
    
    func setUsername(newUsername : String){
        
        userId = newUsername
    }
    
    func getMobileNumber()->String{
        return mobileNumber
    }
    
    func setMobileNumber(newNumber : String){
        
        mobileNumber = newNumber
    }
    
    func getBuilding()->String{
        return building
    }
    
    func setBuilding(newBuilding : String){
        
        building = newBuilding
    }
    
    func setPassword(pass : String){
        
        password = pass
    }
    
    func printUser(){
        print("\n")
        print("UserId :" + userId)
        print("Name :" + fullName)
        print("Email :" + email)
        print("Username : " + username)
        print("Password : " + password)
        print("Building : " + building)
        print("Room Number : " + dormRoom)
        print("Mobile Number : " + mobileNumber)
        
        
    }
    
    
}
