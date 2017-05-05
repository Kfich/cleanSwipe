//
//  TermsViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 11/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UIWebViewDelegate{

    // Properties
    // ===========================
    
    
    // IBOutlets
    // ===========================
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        self.webView.delegate = self
        let url = URL(string: "http://cleanswipe.co/CS_Terms.pdf")
        let request = URLRequest(url: url!)
        //self.webView.scalesPageToFit = true
        self.webView.loadRequest(request)
        
        loadingNotification.hide(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions - Buttons Pressed
    
    @IBAction func denyTerms(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Denied"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptTerms(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Accepted"), object: self)
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
