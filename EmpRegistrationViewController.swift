//
//  EmpRegistrationViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 11/5/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class EmpRegistrationViewController: UIViewController, UIWebViewDelegate{
    
    // Properties
    // =================================
    
    
    // IBOutlets
    // =================================
    @IBOutlet var webView: UIWebView!
    

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        self.webView.delegate = self
        let url = URL(string: "http://cleanswipe.co/form.html")
        let request = URLRequest(url: url!)
        //self.webView.scalesPageToFit = true
        self.webView.loadRequest(request)
        
        loadingNotification.hide(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
