//
//  PaymentConfirmationViewController.swift
//  CleanSwipe0-1
//
//  Created by Hedgeable on 7/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class PaymentConfirmationViewController: UIViewController {
    
    // Properties
    // ==========================
    
    
    // IBOutlets
    // ==========================
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ===========================
    
    @IBAction func okButtonPressed(_ sender: AnyObject) {
        
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
