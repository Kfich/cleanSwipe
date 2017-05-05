//
//  LandingPageViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/3/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class LandingPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    fileprivate var pageViewController: UIPageViewController?
    var isEmployee = false
    
    // Initialize it right away here
    fileprivate let contentImages = ["langingBG.png",
        "langingBG.png",
        "langingBG.png",
        "langingBG.png"];
    
    fileprivate let screenshotImages = ["ss_launchScreen.png",
                                 "ss_selectDate.png",
                                 "ss_orderConfirmation.png",
                                 "ss_home.png"];
    
    fileprivate let titles = ["Clean & Simple",
                                 "On Your Schedule",
                                 "Review & Enjoy!",
                                 "Calling All Canes!"];
    
    fileprivate let quotes = ["CleanSwipe provides a swift, easy way to get your laundry done on campus.",
                          "Schedule your first laundry pickup in just 3 quick steps.",
                          "We love to hear from you. After each drop off, rate and review the service.",
                          "Register using @miami.edu email and begin getting laundry done today!"];

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
        
        print("Is the this landing page?")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let ref = Firebase(url: "https://cleanswipe.firebaseio.com")

        ref?.observeAuthEvent({ authData in
            if authData != nil {
                // user authenticated
                print(authData)
         //       print((authData.providerData["email"]))
                
               // AuthManager.sharedManager.email = authData.providerData["email"] as! String
               // AuthManager.sharedManager.password = authData.provider
                
                print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")
                //self.retrieveDefaultUser()
                
                // Bool test on the last login email to see if it was a cleanswiper or not 
                // Result determines which root view controller to set 
                
                self.retrieveLastLogin()
                
                if self.isEmployee{
                    self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmpMainViewController")
                    self.view.window?.makeKeyAndVisible()
                }else{
                    self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                    self.view.window?.makeKeyAndVisible()
                }
                
                
               // print(authData.token)
                
                
            } else {
                // No user is signed in
                
                print("There is no user logged in")
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })

        
        
    }
    
    // ======================
    
    @IBAction func postData(_ sender: AnyObject) {
        
        let n = Networking()
        
        //n.genericTestPostCall2()
        
        //n.authPostCall("kev@cleanswipe.co", password: "password")
        //n.resetPostCall("kaf31@miami.edu")
        
        let dictionary = ["email": "peter@cleanswipe.co",
                          "password": "password",
                          "name" : "Hello",
                          "mobile_number" : "1234567890",
                          "employeeId": "JYv5SnOjfeSW8VVCSmFtNMyNI2L2"]
        

        n.postCall(dictionary as NSDictionary, endpoint:"/devices")
        
    }
    
    
    
    // ======================
    
    fileprivate func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.view.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height-45)

        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers((startingViewControllers as! [UIViewController]), direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightText
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.clear
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            pageItemController.screenShotImageName = screenshotImages[itemIndex]
            pageItemController.titleString = titles[itemIndex]
            pageItemController.quote = quotes[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    // MARK: Page styling
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Custom methods
    // =========================
    
    func retrieveDefaultUser() -> NSDictionary{
        
        var user = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "emp_credentials") != nil{
            
            user = userInfo.value(forKey: "emp_credentials") as! NSDictionary
            print("Credentials: \(user)")
            
            //isEmployee = true
            
        }else{
            print("This is not an employee")
            //isEmployee = false
        }
        return user
    }
    
    func retrieveLastLogin() {
        
        var emailDict = NSDictionary()
        let userInfo = UserDefaults.standard
        // Check last email login
        if userInfo.value(forKey: "login_email") != nil{
            
            emailDict = userInfo.value(forKey: "login_email") as! NSDictionary
            print("\nLast email: \(emailDict)")
            
            let email = emailDict.object(forKey: "email") as! String
            
            if AuthManager.sharedManager.isValidEmpEmail(email) {
                print("THIS MOTHER FUCK WAS AND EMP")
                isEmployee = true
            }
        }else{
            print("No one has logged in")
            isEmployee = false
        }
    }
    
    
}
