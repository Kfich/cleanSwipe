//
//  BagSelectionViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/14/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class BagSelectionViewController: UIViewController, UITextFieldDelegate{
    // Properties
    // =====================================
    
    var currentUser = User()
    var appointment = AppointmentManager.sharedManager.appointment
    var now = Date()
    let tomorrow = Date()
    var selectedOrderDate : String = ""
    var pickupWindow : String = ""
    
    var swipeRec = UISwipeGestureRecognizer()
    var swipeRecBack = UISwipeGestureRecognizer()
    
    var keyboardVisible : Bool = false
    
    // IBOutlets
    // =====================================
    
    @IBOutlet var dryCleaningButton: UIButton!
    @IBOutlet var dryCleaningCheckImage: UIImageView!
    
    @IBOutlet var laundryButton: UIButton!
    @IBOutlet var laundryCheckImage: UIImageView!
    
    @IBOutlet var notesTextField: UITextField!

    @IBOutlet var pickupWindowLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Swipe. Clean. Done."
        
        
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(BagSelectionViewController.swipedView(_:)))
        swipeRec.direction = .left
        
        swipeRecBack = UISwipeGestureRecognizer(target: self, action: #selector(BagSelectionViewController.swipedBack(_:)))
        swipeRecBack.direction = .right
        
        self.view.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(swipeRecBack)
        
        // Page configuration
        configureViewController()
        
        print("Hey Kev ya did it!")
        currentUser.printUser()
        
        
        // Step view configuration
        addObservers()
        notesTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //configureStepper()
        
        //configureDatePicker(self.datePicker)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Buttons Pressed // IBActions
    // ==========================================
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        //bagsLabel.text = Int(sender.value).description
    }
    
    @IBAction func dateSelected(_ sender: AnyObject) {
        
        /*let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)*/
    }
    
    
    @IBAction func dryCleaningSelected(_ sender: AnyObject) {
        
        // Push the segue
        
        self.performSegue(withIdentifier: "showDryCleaning", sender: self)
        
    }
    
    
    @IBAction func laundrySelected(_ sender: AnyObject) {
        
        // Push seggy
        self.performSegue(withIdentifier: "showLaundrySelection", sender: self)
    }
    
    
    
    @IBAction func pickupTimeSelected(_ sender: AnyObject) {
        
        if keyboardVisible {
            print("Keyboard active")
        }else{
            var current = Date()
            let min = Date().addingTimeInterval(86400)
            let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
            let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.doneButtonTitle = "DONE"
            
            picker.completionHandler = { date in
                current = date
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy"
                self.selectedOrderDate = formatter.string(from: current)
                self.pickupWindow = picker.selectedDateString
                print("\n\nSELECTED ORDER DATE: \(self.selectedOrderDate) \(self.pickupWindow)")
                self.pickupWindowLabel.text = self.selectedOrderDate + " - " + self.pickupWindow
                let swiftColor = UIColor(red: 85/255.0, green: 217/255.0, blue: 188/255.0, alpha: 1)
                self.pickupWindowLabel.textColor = swiftColor
            }
            
            print("Keyboard not active")
        }

        
        
    }
    
    
    
    // Custom methods
    // =========================================
    
    func configureViewController(){
        
        // Configure buttons 
        
        dryCleaningButton.layer.borderColor = UIColor.lightGray.cgColor
        dryCleaningButton.layer.borderWidth = 1.0
        dryCleaningButton.layer.cornerRadius = 10.0
        dryCleaningButton.layer.masksToBounds = true
        
        laundryButton.layer.borderColor = UIColor.lightGray.cgColor
        laundryButton.layer.borderWidth = 1.0
        laundryButton.layer.cornerRadius = 10.0
        laundryButton.layer.masksToBounds = true
        
        // Configure button and image
        
        
        if AppointmentManager.sharedManager.userSelectedDryCleaning {
            dryCleaningCheckImage.isHidden = false
        }else{
            dryCleaningCheckImage.isHidden = true
        }
        
        if AppointmentManager.sharedManager.userSelectedLaundry {
            laundryCheckImage.isHidden = false
        }else{
            laundryCheckImage.isHidden = true
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(BagSelectionViewController.configureViewController), name: NSNotification.Name(rawValue: "User Selected Service"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(BagSelectionViewController.keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(BagSelectionViewController.keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    // Keyboard Delegate
    
    
    func keyboardWillAppear(notification: NSNotification){
        // Do something here
        self.keyboardVisible = true
        print("\(keyboardVisible)")
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        // Do something here
        self.keyboardVisible = false
        print("\(keyboardVisible)")
        
    }
    
    
    func swipedView(_ gesture: UIGestureRecognizer){
        
        // Validation checks for the form 
        if ((laundryCheckImage.isHidden == false || dryCleaningCheckImage.isHidden == false) && pickupWindowLabel.text != "No time selected") {
            self.performSegue(withIdentifier: "showConfirmPayment", sender: self)
        }
    }
    
    func swipedBack(_ gesture: UIGestureRecognizer){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 160 // Bool
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showConfirmPayment") {
            
            print("SEGUE HAPPENING")
            print(appointment.price)
           // Set pickupdate here 
            //let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            //let strDate = dateFormatter.string(from: datePicker.date)
            
            
            self.appointment.numberOfItems = AppointmentManager.sharedManager.cart.count + AppointmentManager.sharedManager.appointment.numberOfBags!
            self.appointment.setTransactionId()
            self.appointment.customerId = self.currentUser.userId
            self.appointment.building = self.currentUser.building
            self.appointment.dormRoom = self.currentUser.dormRoom
            self.appointment.mobileNumber = self.currentUser.mobileNumber
            self.appointment.location = "University of Miami"
            self.appointment.employeeId = ""
            self.appointment.orderDate = selectedOrderDate
            self.appointment.pickupDate = selectedOrderDate + " " + pickupWindow
            self.appointment.price = AppointmentManager.sharedManager.calculateTotal() + 2
            
            if notesTextField.text != ""{
                self.appointment.notes = self.notesTextField.text!
            }else{
                self.appointment.notes = ""
            }
            
            
            let payVC = (segue.destination as! ConfirmPaymentViewController)
            payVC.currentUser = self.currentUser
            payVC.appointment = self.appointment
            
            
            // Calculate Payment
            appointment.printAppointment()
            
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            
        }
        
        
    }
    
}
