//
//  PreferencesViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/18/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

    // Properties
    // =========================================
    
    var swipeRec = UISwipeGestureRecognizer()
    var swipeRecBack = UISwipeGestureRecognizer()
    var currentUser = User()
    var appointment = Appointment()
    
    let tomorrow = Date()
    let blue_green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
    let green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    
    // IBOutlets
    // ========================================
    
    @IBOutlet weak var twoDollarButton: UIBarButtonItem!

    @IBOutlet weak var threeDollarButton: UIBarButtonItem!
    
    @IBOutlet weak var fourDollarButton: UIBarButtonItem!
    
    @IBOutlet weak var fiveDollarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Swipe. Clean. Done."
        
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(PreferencesViewController.swipedView(_:)))
        swipeRec.direction = .left
        
        swipeRecBack = UISwipeGestureRecognizer(target: self, action: #selector(PreferencesViewController.swipedBack(_:)))
        swipeRecBack.direction = .right
        
        self.view.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(swipeRecBack)
        configureButtons()
        
        currentUser.printUser()
        print("\n Kevin")
       // appointment.printAppointment()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions // Buttons Pressed
    // ==========================================
    
    @IBAction func addTwoDollarTip(_ sender: AnyObject) {
        appointment.preferences.tip = 2.0
        
        // Configure button color 
        
        if (twoDollarButton.tintColor == green){
            twoDollarButton.tintColor = blue_green
        }else{
            twoDollarButton.tintColor = green
        }
        
    }
    
    @IBAction func addThreeDollarTip(_ sender: AnyObject) {
        appointment.preferences.tip = 3.0
        
        if (threeDollarButton.tintColor == green){
            threeDollarButton.tintColor = blue_green
        }else{
            threeDollarButton.tintColor = green
            appointment.preferences.tip = 0.0
        }
    }
    
    @IBAction func addFourDollarTip(_ sender: AnyObject) {
        appointment.preferences.tip = 4.0
        
        if (fourDollarButton.tintColor == green){
            fourDollarButton.tintColor = blue_green
        }else{
            fourDollarButton.tintColor = green
            appointment.preferences.tip = 0.0
        }
    }
    
    @IBAction func addFiveDollarTip(_ sender: AnyObject) {
        appointment.preferences.tip = 5.0
        
        if (fiveDollarButton.tintColor == green){
            fiveDollarButton.tintColor = blue_green
        }else{
            fiveDollarButton.tintColor = green
            appointment.preferences.tip = 0.0
        }

    }
    // Custom methods
    // ==========================================
    
    func configureButtons() {
        
        twoDollarButton.tintColor = green
        threeDollarButton.tintColor = green
        fourDollarButton.tintColor = green
        fiveDollarButton.tintColor = green
        
    }
    
    
    func swipedView(_ gesture: UIGestureRecognizer){
        
        
        self.performSegue(withIdentifier: "showPaymentMethod", sender: self)
        
    }
    
    func swipedBack(_ gesture: UIGestureRecognizer){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPaymentMethod") {
            
            // Calculate appointment price 
            //appointment.calculatePrice()
            
            // Set delivery notes 
            if (notesTextView.text != nil){
                self.appointment.preferences.notes = notesTextView.text
            }
            
            let paymentVC = (segue.destination as! PaymentViewController)
            paymentVC.currentUser = self.currentUser
            paymentVC.appointment = self.appointment
            
      //      let backItem = UIBarButtonItem()
      //      backItem.title = " "
      //      navigationItem.backBarButtonItem = backItem
       //     navigationItem.setHidesBackButton(true, animated: false)
            
            
            
        }
        
    }
    

}
