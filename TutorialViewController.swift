//
//  TutorialViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 1/25/17.
//  Copyright © 2017 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class TutorialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Properties
    // =============================
    var isEmployee : Bool = false
    var currentUser = User()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Welcome to CleanSwipe", message: "Swipe. Clean. Done.", imageName: "page1")
        
        let secondPage = Page(title: "Laundry and Dry Cleaning", message: "CleanSwipe offers both wash & fold and Dry Cleaning services.", imageName: "page2")
        
        let thirdPage = Page(title: "On Demand, On Your Schedule", message: "Our hassle-free scheduler tool allows you to order a pickup in a just a few swipes.", imageName: "page3")
        
        let fourthPage = Page(title: "Real Time Tracking", message: "Know exactly where your clothes are at all times and receive notifications along the entire process.", imageName: "page4")
        
        let fifthPage = Page(title: "We ❤️ Our Users", message: "New users enter promo code MIAMI2017 on signup and receive a $5 dollar credit towards your first order.", imageName: "page5")
        
        return [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 27/255, green: 205/255, blue: 137/255, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    func skip() {
        // we only need to lines to do this
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    func nextPage() {
        //we are on the last page
        if pageControl.currentPage == pages.count {
            return
        }
        
        //second last page
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    // Page Setup
    // =================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Nav bar 
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add keyboard delegates
        observeKeyboardNotifications()
        
        // Configure subviews
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        // Add Controller
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        
        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        //use autolayout instead
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerCells()
        
        // Add Observers
        addObservers()
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

    // Keyboard Delegates
    //
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            //back on regular pages
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    
    // Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath)
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        //scroll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        
    }
    
    // Data Retrieval
    
    // Custom methods
    // =========================
    // Login should be changed to forgotPassword
    
    func loginUser(){
        
        if AuthManager.sharedManager.isValidEmail(currentUser.email) {
            
            // Configure loading indicator
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"
            
            let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
            
            ref?.authUser(currentUser.email, password: currentUser.password,
                          withCompletionBlock: { error, authData in
                            if error != nil {
                                // There was an error logging in to this account
                                print("There was an error logging in")
                                // Show error message here
                                
                                // Hide loading indicator
                                loadingNotification.hide(animated: true)
                                
                                let alert = UIAlertController(title: "There was a problem", message: "Please make sure you enter a valid email/password.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                
                            } else {
                                // We are now logged in
                                
                                print("Yahoo, we loggin in successfully!")
                                
                                AuthManager.sharedManager.email = self.currentUser.email
                                AuthManager.sharedManager.password = self.currentUser.password
                                
                                // Store last email
                                let email = ["email": self.currentUser.email]
                                AuthManager.sharedManager.rememberLastEmail(email as NSDictionary)
                                
                                
                                // Store current credentials
                                let credentials = ["email": self.currentUser.email, "password":self.currentUser.password]
                                AuthManager.sharedManager.rememberUserCredentials(credentials as NSDictionary)
                                
                                loadingNotification.hide(animated: true)
                                
                                print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")
                                
                                
                                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                                self.view.window?.makeKeyAndVisible()
                                
                            }
            })
            
        }else{
            // Show ok alert
            let alert = UIAlertController(title: "There was a problem", message: "Please make sure you enter a valid miami email address.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
    
    func pushLoginSegue(){
        
        // Strip white characters on login
        
        currentUser.email = AuthManager.sharedManager.email
        currentUser.password = AuthManager.sharedManager.password
        
        

        loginUser()
        //print("This should be login logic")
    }
    func pushWorkSegue(){
        
        self.performSegue(withIdentifier: "showWorkLogin", sender: self)
    }
    func pushSignupSegue(){
        
        self.performSegue(withIdentifier: "showSignup", sender: self)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.pushLoginSegue), name: NSNotification.Name(rawValue: "User Login"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.pushWorkSegue), name: NSNotification.Name(rawValue: "Work Login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.pushSignupSegue), name: NSNotification.Name(rawValue: "Signup"), object: nil)
        
    }

    
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
    
    // Navigation
    
    
    
}

