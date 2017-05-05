//
//  PaymentSuccessViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 9/12/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: UIViewController {
    
    // Properties
    // ========================
    var currentUser = User()
    
    // IBOutlets
    // ========================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Clear user account credit after purchase
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // =========================
    
    @IBAction func returnToHome(_ sender: AnyObject) {

        
        // Update User Info
        
        let user = [
            "name" : self.currentUser.fullName,
            "username" : self.currentUser.username,
            "email": self.currentUser.email,
            "dorm" : self.currentUser.building,
            "room_number" : self.currentUser.dormRoom,
            "mobile_number" : self.currentUser.mobileNumber,
            "referral_code" : self.currentUser.referralCode,
            "credit" : 0
            ] as [String : Any]
        
        AppointmentManager.sharedManager.creditUserAccount(userDict: user, userId: currentUser.userId)
        
        
        // Reset manager
        AppointmentManager.sharedManager.reset()
        
        self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
