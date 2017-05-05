//
//  LaundryViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 1/23/17.
//  Copyright © 2017 Kevin Fich. All rights reserved.
//

import UIKit


class LaundryViewController: UIViewController {
    
    // Properties
    // ===========================
    
    
    
    
    // IBOutlets
    // ===========================
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var bagsLabel: UILabel!
    @IBOutlet var stepperWrapperView: GMStepper!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configure Views 
        
        //configureViewController()
        
        //stepperWrapperView.value
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        stepperWrapperView.value = Double(AppointmentManager.sharedManager.appointment.numberOfBags!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions // Buttons Pressed
    
    @IBAction func doneSelectingBags(_ sender: AnyObject) {
        
        // Calculate the new order total
        let value = Int(stepperWrapperView.value)
        
        /*
        // Update total price on appointment manager if user has selected drycleaning
        // Else calculate the total here and set the value
        if AppointmentManager.sharedManager.userSelectedDryCleaning && value != 0{
            AppointmentManager.sharedManager.appointment.calculatePrice(numOfBags: value)
            print("\n\n\nAPT MANAGER PRICE")
            print(AppointmentManager.sharedManager.appointment.price)
        }else if AppointmentManager.sharedManager.userSelectedDryCleaning != true && value != 0 {
            // Calculate price
            AppointmentManager.sharedManager.appointment.price = (Double(value) * 14.0)
        
            print("\n\n\nAPT MANAGER UPDATED PRICE")
            print(AppointmentManager.sharedManager.appointment.price)

        }
        */
        
        // If items were selected, then post notification and add the value 
        
        if value != 0 {
            
            // Set appointment manager has selected to true
            AppointmentManager.sharedManager.userSelectedLaundry = true
            // Add bags to items list on apt manager
            
            //AppointmentManager.sharedManager.appointment.numberOfItems += value
            
            // Post notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "User Selected Service"), object: self)
        }
        
        // Assign bag value
        AppointmentManager.sharedManager.appointment.numberOfBags = value
        
        self.presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            //print("bye")
            
        })
        
        }
    
    
    @IBAction func stepperValueChanged(_ sender: AnyObject) {
        
        //bagsLabel.text = "5"
    }
    
    
    
    // Custom methods
    
   /* func configureViewController(){
        
        stepperWrapperView.layer.borderWidth = 1.0
        stepperWrapperView.layer.cornerRadius = 10.0
        stepperWrapperView.layer.masksToBounds = true
        
        configureStepper()
        
    }*/
    
    /*func configureStepper(){
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 5
        stepper.minimumValue = 1
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
