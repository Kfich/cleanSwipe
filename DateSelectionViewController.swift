//
//  DateSelectionViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/14/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class DateSelectionViewController: UIViewController {
    // Properties
    // =========================================
    
    var swipeRec = UISwipeGestureRecognizer()
    var swipeRecBack = UISwipeGestureRecognizer()
    var currentUser = User()
    var appointment = Appointment()
    
    let tomorrow = Date()

    
    
    // IBOutlets
    // ========================================
    
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Swipe. Clean. Done."
        
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(DateSelectionViewController.swipedView(_:)))
        swipeRec.direction = .left
        
        swipeRecBack = UISwipeGestureRecognizer(target: self, action: #selector(DateSelectionViewController.swipedBack(_:)))
        swipeRecBack.direction = .right
        
        self.view.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(swipeRecBack)
        
        currentUser.printUser()
        print("\n Kevin")
        appointment.printAppointment()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureDatePicker(self.datePicker)
        
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions // Buttons Pressed
    // ==========================================
    
    @IBAction func dateSelected(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)
    }
    
    
    
    // Custom methods
    // ==========================================
    
    func configureDatePicker(_ datePicker: UIDatePicker){
    //    let minimumHour = 8;
    //    let maximumHour = 22;
        
        datePicker.minuteInterval = 15
        
        let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.day = components.day!+1
        let minDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
      //  components.hour = minimumHour
        
        /*
        components.hour = minimumHour
        components.minute = 0
        components.second = 0
        let startDate: NSDate = gregorian.dateFromComponents(components)!
        components.hour = maximumHour
        components.minute = 0
        components.second = 0
        let endDate: NSDate = gregorian.dateFromComponents(components)!
        datePicker.datePickerMode = .Time
        datePicker.minimumDate = startDate
        datePicker.maximumDate = endDate
        datePicker.setDate(startDate, animated: true)
        */
        self.datePicker.minimumDate = minDate
    }
    
    func swipedView(_ gesture: UIGestureRecognizer){
        
        self.performSegue(withIdentifier: "showPreferences", sender: self)
    }
    
    func swipedBack(_ gesture: UIGestureRecognizer){

        //navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if (segue.identifier == "showPreferences") {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let strDate = dateFormatter.string(from: datePicker.date)
            
            self.appointment.pickupDate = strDate
            
            let prefsVC = (segue.destination as! PreferencesViewController)
            prefsVC.currentUser = self.currentUser
            prefsVC.appointment = self.appointment
            
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            
            
            
        }
    }
    

}
