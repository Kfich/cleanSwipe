//
//  RegistrationP1ViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/4/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class RegistrationP1ViewController: UIViewController {
    
    // Properties
    // =============================================
    
    let newUser = User()
    
    // IBOutlets
    // =============================================
    
    @IBOutlet weak var textFieldWrapperView: UIView!
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    // =============================================

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // bgScrollView.addSubview(textFieldWrapperView)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        bgScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        bgScrollView.isScrollEnabled = true
        
        bgScrollView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height)

        bgScrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.view.frame.size.height/2);
        
        firstNameTextField.becomeFirstResponder()

        // Add observers for terms response
        addObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Registration Validation
    // ====================================================
    
    @IBAction func continueToStep2(_ sender: AnyObject) {
        
        
        newUser.firstName = self.firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        newUser.lastName = self.lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        newUser.email = self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        newUser.username = self.usernameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        newUser.password = self.passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let confirmPasswordString = self.confirmPasswordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        
        print("Email: \(newUser.email)  Password: \(newUser.password)")
        
        if newUser.password.characters.count < 6 || confirmPasswordString.characters.count < 6 || confirmPasswordString != newUser.password || newUser.email.characters.count == 0 || !self.validateEmail(newUser.email) || newUser.firstName.characters.count == 0 || newUser.lastName.characters.count == 0 || newUser.username.characters.count == 0 {

            let alert = UIAlertController(title: "Sorry, there was a problem", message: "Please make sure you enter a valid information.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            

        }
        else {
            let alert = UIAlertController(title: "Welcome", message: "By continuing, you are agreeing to CleanSwipe's Terms of Service & Privacy Policy, which is viewable by selecting View Terms from the options below.", preferredStyle: .alert)
            
            let agree = UIAlertAction(title: "Agree", style: .default, handler: {(action: UIAlertAction) -> Void in
                //alert.dismissViewControllerAnimated(true, completion: { _ in })
                self.performSegue(withIdentifier: "showRegisterStep2", sender: self)
                
            })
            let viewTerms = UIAlertAction(title: "View Terms", style: .default, handler: {(action: UIAlertAction) -> Void in
                //alert.dismissViewControllerAnimated(true, completion: { _ in })
                print("View terms selected")
                self.performSegue(withIdentifier: "showTerms", sender: self)
                
            })
            

            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: { _ in })
            })
           
            alert.addAction(viewTerms)
            alert.addAction(agree)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: { _ in })
        }
    }
    
    // Custom methods
    // =====================
    
    func validateEmail(_ candidate: String) -> Bool {
        //  Original Regex
        //  let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        // @miami.edu Regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@miami.edu"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: candidate)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationP1ViewController.termsAccepted), name: NSNotification.Name(rawValue: "Accpeted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationP1ViewController.termsDenied), name: NSNotification.Name(rawValue: "Denied"), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func termsAccepted() {
        self.performSegue(withIdentifier: "showRegisterStep2", sender: self)
    }
    
    func termsDenied(){
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "showRegisterStep2") {
            
            newUser.firstName = firstNameTextField.text!
            newUser.lastName = lastNameTextField.text!
            newUser.email = emailTextField.text!
            newUser.username = usernameTextField.text!
            newUser.password = passwordTextField.text!
            
            let destinationVC = segue.destination as! RegistrationP2ViewController
            destinationVC.currentUser = newUser
            
            
        }
    }


}












