//
//  Networking.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/22/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import AFNetworking

open class Networking{
    
    let kevIphone = "1bd5f4923a92cf461d7a08b7dae6ef1e2ae3cd077e0b7443d81167903f070178"
    
    init() {}
    
    
    func genericPostCall(_ userId : String, deviceToken: String){
     
        let urlString = "http://52.55.249.87/cleanSwipe/CleanSwipePush/appointment_push.php"
        
        
        let dictionary = ["token": deviceToken, "user_id": userId, "message": "Your appointment has been dispatched. \n Status: Processing"]
        
        let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.post(urlString, parameters: dictionary, success:
                {
                    requestOperation, response in
                
                        let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                        print(result)
                },
                    failure:
                {
                    requestOperation, error in
                        print("error occured while posting")
        })
    }
    
    
    func postPushForAppointmentUpdate(_ userId : String, message: String, token: String) {
        
        
        // Here, insert the url for the amazon server
        
        let urlString = "http://52.55.249.87/cleanSwipe/CleanSwipePush/client_push.php"
        //let urlString = "http://localhost/CleanSwipePush/appointment_push.php"
        let dictionary:[String: AnyObject] = ["deviceToken" : token as AnyObject, "userId" : userId as AnyObject, "message" : message as AnyObject]
        print("PARAMS PARAMS")
        print("PARAMS PARAMS")
        print("PARAMS PARAMS \(dictionary)")
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(urlString, parameters: dictionary, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                print("\n\nCLIENT PUSH\n\n")
                print("SUCCESS SUCCESS SUCCESS")
                print("SUCCESS SUCCESS SUCCESS")
                print(result)
                print("END OF SUCCESS")
            },
                     failure:
            {
                requestOperation, error in
                print("\n\nCLINET PUSH ERROR\n\n")
                print("ERROR ERROR")
                print("ERROR ERROR")
                print("error occured while posting")
        })
    }
    
    func authPostCall(_ email : String, password: String){
        
        let urlString = "http://127.0.0.1:5000/auth"
        
        
        let dictionary = ["email": email, "password": password]
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(urlString, parameters: dictionary, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                print("\n\nCLIENT PUSH\n\n")
                print("SUCCESS SUCCESS SUCCESS")
                print("SUCCESS SUCCESS SUCCESS")
                print(result)
                print("\n\nCLIENT PUSH\n\n")
                print("SUCCESS SUCCESS SUCCESS")
                print("SUCCESS SUCCESS SUCCESS")
            },
                     failure:
            {
                requestOperation, error in
                print("error occured while posting")
        })
    }
    
    func resetPostCall(_ email : String){
        
        let urlString = "http://127.0.0.1:5000/reset_password"
        
        
        let dictionary = ["email": email]
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(urlString, parameters: dictionary, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                print(result)
            },
                     failure:
            {
                requestOperation, error in
                print("error occured while posting")
        })
    }

    func postCall(_ params: NSDictionary, endpoint: String){
        
        let urlString = "http://127.0.0.1:5000\(endpoint)"
        
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(urlString, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                print("\n\nCLIENT PUSH\n\n")
                print("SUCCESS SUCCESS SUCCESS")
                print("SUCCESS SUCCESS SUCCESS")
                print(result)
                print("\n\nCLIENT PUSH\n\n")
                print("SUCCESS SUCCESS SUCCESS")
                print("SUCCESS SUCCESS SUCCESS")
            },
                     failure:
            {
                requestOperation, error in
                print("error occured while posting")
        })
    }

}



