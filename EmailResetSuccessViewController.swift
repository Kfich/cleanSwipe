//
//  EmailResetSuccessViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 9/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class EmailResetSuccessViewController: UIViewController {
    
    // Properties
    // ===============================

    // IBOutlets
    // ===============================
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ================================
    
    @IBAction func returnToHomeVC(_ sender: AnyObject) {
        
        self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageVC")
        self.view.window?.makeKeyAndVisible()
    }
}
