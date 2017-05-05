//
//  LoginCell.swift
//  audible
//
//  Created by Brian Voong on 9/17/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    // Properties
    //
    var email : String = ""
    var password : String = ""
    
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        
        let csFont = UIFont(name: "Geomanist-Regular", size: 16)!
        textField.font = csFont
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.placeholder = "Enter email"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        
        let csFont = UIFont(name: "Geomanist-Regular", size: 16)!
        textField.font = csFont
        textField.placeholder = "Enter password"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let csGreen = UIColor(red: 27/255, green: 205/255, blue: 137/255, alpha: 1.0)
        let button = UIButton(type: .system)
        button.backgroundColor = csGreen
        button.layer.cornerRadius = 20
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let csFont = UIFont(name: "Geomanist-Regular", size: 18)!
        button.titleLabel?.font = csFont
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.setTitle("Signup", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        
        let csFont = UIFont(name: "Geomanist-Regular", size: 18)!
        button.titleLabel?.font = csFont
        
        return button
    }()
    
    let forgotButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.setTitle("Forgot", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        
        return button
    }()
    
    let workButton: UIButton = {
        let csBlue = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        let button = UIButton(type: .system)
        button.backgroundColor = csBlue
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.setTitle("Work for CleanSwipe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let csFont = UIFont(name: "Geomanist-Regular", size: 18)!
        button.titleLabel?.font = csFont
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
      //  addSubview(forgotButton)
        addSubview(signupButton)
        addSubview(workButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -300, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 200)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = emailTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = loginButton.anchor(passwordTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 37, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = signupButton.anchor(loginButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
         _ = workButton.anchor(signupButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        
        loginButton.addTarget(self, action: #selector(LoginCell.postLoginNotification), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(LoginCell.postSignupNotification), for: .touchUpInside)
        workButton.addTarget(self, action: #selector(LoginCell.postWorkNotification), for: .touchUpInside)
        //NSNotificationCenter.defaultCenter().postNotificationName("Employee List", object: self)
        
        // Check for default password
        
        _ = retrieveDefaultUser()
    }
    
    // Device memory
    func retrieveDefaultUser() -> NSDictionary{
        
        var user = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "auth_credentials") != nil{
            
            user = userInfo.value(forKey: "auth_credentials") as! NSDictionary
            print("Credentials: \(user)")
            
            self.email = user.value(forKey: "email") as! String
            self.password = user.value(forKey: "password") as! String
            
            print("\nUsername: \(self.email) Password: \(self.password)")
            self.emailTextField.text = self.email
            self.passwordTextField.text = self.password
            
            
        }else{
            print("There was no username or password")
        }
        return user
    }
    
    
    
    // Notification Center
    func postLoginNotification(){
        
        // Set Manager data
    
        
        AuthManager.sharedManager.email = emailTextField.text!
        AuthManager.sharedManager.password = passwordTextField.text!
        
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "User Login"), object: self)
    }
    
    func postWorkNotification(){
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Work Login"), object: self)
    }
    func postSignupNotification(){
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Signup"), object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    
}








