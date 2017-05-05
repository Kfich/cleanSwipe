//
//  EmpMainViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/23/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase



class EmpMainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // ======================================================
    
    var transactionList = [Appointment]()
    var empList = [Employee]()

    var currentTransactionList = [Appointment]()
    var selectedAppointment = Appointment ()
    var currentEmp = Employee()
    
    @IBOutlet var collectionView: UICollectionView!
    
    let dateFormatter = DateFormatter()
    
    // Menu Configuration
    // ==================
    
    lazy var menuLauncher: MenuLauncher2 = {
        let launcher = MenuLauncher2()
        launcher.homeController = self
        return launcher
    }()
    
    
    func handleMore() {
        
        menuLauncher.showMenu()
    }
    
    // Menu VC
    
    func transitionViewController(_ settingString: String) {
        menuLauncher.homeController = self
        print(settingString)
        if settingString == "Pickup History" {
            
            performSegue(withIdentifier: "showEmpHistory", sender: self)
            
        }else if settingString == "Contact CleanSwipe" {
            
            performSegue(withIdentifier: "showContactUs", sender: self)
        
        }else if settingString == "Logout" {
            // logout 
            // Create alert
            let alert = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            let agree = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
                
                //  Reset appointment and go home
                
                let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
                
                ref?.unauth()
                
                // Reset Manager classes
                AuthManager.sharedManager.reset()
                PaymentManager.sharedManager.reset()
                
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageVC")
                self.view.window?.makeKeyAndVisible()
                
            })
            
            
            // Create notNow action
            let notNow = UIAlertAction(title: "Forget it", style: .default, handler: {(action: UIAlertAction) -> Void in
                
                // Dismiss the alert
                alert.dismiss(animated: true, completion: { _ in })
                
            })
            
            alert.addAction(agree)
            alert.addAction(notNow)
            self.present(alert, animated: true, completion: { _ in })
            
            
            // self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
    }
    

    
    // IBOutlets
    // ======================================================
    
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var currentOrdersTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        currentTransactionList = [Appointment]()
        //currentUser.printUser()
        
        // Query first for user list with AppointmentManager
        AppointmentManager.sharedManager.queryForUserList()
        
        // Register TransactionCell
        
        historyTableView.register(UINib(nibName: "TransactionViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        
        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        let ref = Firebase(url:"https://cleanswipe.firebaseio.com")
        
        // Query backend to retrieve array of Transactions for currentUser
        let ref2 = Firebase(url:"https://cleanswipe.firebaseio.com/employees")

        ref?.observeAuthEvent({ authData in
            if authData != nil {
                // user authenticated
                // print("A user \(authData) is logged in")
                // print(authData)
                
                print(authData?.auth)
                print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")
                
                // Query db and return user data based on uid
                
                ref2?.queryOrdered(byChild: "uid").observe(.value, with: { snapshot in
                    
                    
                    for child in (snapshot?.children)! {
                        
                        /*
                         let childSnapshot = snapshot.childSnapshotForPath(child.key)
                         print(childSnapshot)
                         */
                        
                        let user = Employee(snapshot: child as! FDataSnapshot)
                        print(user.getName())
                        print(user.empId)
                        self.empList.append(user)
                        
                        if user.empId == authData?.uid{
                            
                            self.currentEmp = user
                            
                            self.currentEmp.printEmployee()
                            // Backend for data
                            self.queryForTransactionData()
                            
                            //print("\n\nUser Creds: \(AuthManager.sharedManager.retrieveUserCredentials())")
                            
                        }
                        
                        loadingNotification.hide(animated: true)
                        // store/update token info
                    }
                })
                
            } else {
                // No user is signed in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })

        /*
        */
    }
    
    override func viewDidLoad() {
       
        /*
        // Add don to db
        let employeesRef = Firebase(url:"https://cleanswipe.firebaseio.com/employees")

        let don = [
            "name": "Don Sirivat",
            "email": "don@cleanswipe.co",
            "mobile_number": "8477495485"
        ]
        
        employeesRef.childByAppendingPath("8H2CxVWsk0a604WldpzsXVTRLkJ3").setValue(don)
        */
        
        // Add observers to listen for post notifications 
        addObservers()
        
        print("WILL APPEAR")
        print(transactionList.count)
        print(currentTransactionList.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //transactionList.removeAll()
        //currentTransactionList.removeAll()
        //removeObservers()
        
        print(transactionList.count)
        print(currentTransactionList.count)
    }
    
    // IBActions
    // ===================================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuPressed(_ sender: AnyObject) {
        
        self.handleMore()
    }
    
    // Custom Methods
    // ===================================
    
    func queryForTransactionData() {
        
        // Reset lists
        transactionList.removeAll()
        currentTransactionList.removeAll()
        
        // Query ref 
        
        let ref2 = Firebase(url:"https://cleanswipe.firebaseio.com/orders")

        ref2?.queryOrdered(byChild: "order_date").observe(.value, with: { snapshot in
            
            for child in (snapshot?.children)! {
                
                let order = Appointment(snapshot: child as! FDataSnapshot)
                
                let strTime = order.pickupDate
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                let s = formatter.date(from: strTime)
                order.sortDate = s
                
                if (order.status != "delivered" && order.employeeId == self.currentEmp.empId){
                    // Active appointments for current cleanswiper
                    self.currentTransactionList.append(order)
                }else if order.status == "processing"{
                    // All available Orders
                    self.transactionList.append(order)
                }
            }
            
            // Date sorting maybe?
            
            self.historyTableView.reloadData()
            self.collectionView.reloadData()
            
            
            print("\n\n\n\nPOST QUERY")
            print(self.transactionList.count)
            print(self.currentTransactionList.count)
            
            // Hide loading notif
        })
    }
    
    
    // Notification center 
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(EmpMainViewController.refreshTableData), name: NSNotification.Name(rawValue: "Status Updated"), object: nil)

    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshTableData() {
        print("REFRESH")
        
        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.customView
        loadingNotification.customView = UIImageView(image: UIImage(named: "CheckmarkGradiant.png"))
        loadingNotification.backgroundColor = UIColor.clear
        loadingNotification.label.text = "Status sucessfully updated"
        
        // Query for table data
        queryForTransactionData()
        self.historyTableView.reloadData()
        self.collectionView.reloadData()
        
        loadingNotification.hide(animated: true, afterDelay: 1.50)

    }
    
    
    // TABLE VIEW DATA SOURCE AND DELEGATES
    // ===================================
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // All Orders tableview configuration
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionViewCell
        
        let transaction = self.transactionList[(indexPath as NSIndexPath).section]
        
        // Format order date string
        let strTime = transaction.orderDate
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //let s = dateFormatter.date(from: strTime)
        
        //dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        //let newDateString = dateFormatter.string(from: s!)
        
        // Format pickup date string
        
        let strTime2 = transaction.pickupDate
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //let s2 = dateFormatter.date(from: strTime2)
        
        //dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        //let newDateString2 = dateFormatter.string(from: s2!)
        
        // Set label text for cell
        
        cell.purchaseDateLabel.text = "Pickup Date:\n\(strTime2)"
        cell.dateLabel.text = "Ordered: \(strTime)"
        
        cell.amountLabel.text = transaction.status.uppercased()
        
        if transaction.status == "processing"{
            cell.amountLabel.textColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
            cell.amountLabel.text = "AVAILABLE"
        }else if transaction.status == "in progress"{
            cell.amountLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        }else if transaction.status == "picked up"{
            cell.amountLabel.textColor = UIColor(red: 36/255.0, green: 110/255.0, blue: 255/255.0, alpha: 1.0)
        }else if transaction.status == "washing"{
            cell.amountLabel.textColor = UIColor(red: 255/255.0, green: 82/255.0, blue: 111/255.0, alpha: 1.0)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        selectedAppointment = transactionList[(indexPath as NSIndexPath).section]
        
        selectedAppointment.printAppointment()
        
        if selectedAppointment.status == "processing" {
            self.performSegue(withIdentifier: "showOrderCheckin", sender: self)
        }else if selectedAppointment.status == "in progress"{
            self.performSegue(withIdentifier: "showPickupDetails", sender: self)
        }else if selectedAppointment.status == "picked up"{
            self.performSegue(withIdentifier: "showWashConfirm", sender: self)
        }else if selectedAppointment.status == "washing"{
            self.performSegue(withIdentifier: "showDropoffDetails", sender: self)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        return containerView
    }
    
    // MARK: UICollectionViewDataSource & Delegate
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return currentTransactionList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AppointmentCell", for: indexPath) as! AppointmentViewCell
        
        // Configure the cell
        
        let order = self.currentTransactionList[(indexPath as NSIndexPath).row]
        cell.bagLabel.text = "Items: \(String(describing: order.numberOfItems))"
        cell.statusLabel.text = order.status.uppercased()
        //cell.layer.borderWidth = 0.5
        //cell.layer.borderColor = UIColor.grayColor().CGColor
        
        
        // Configure date string
        
        let pickupTime = order.pickupDate
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //let s2 = dateFormatter.date(from: pickupTime)
        
        //dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        //let pickupDateString = dateFormatter.string(from: s2!)
        
        cell.pickupDateLabel.text = "Deliver on \(pickupTime)"
        
        // Configure number label
        cell.numberLabel.text = String((indexPath as NSIndexPath).row + 1)
        
        cell.numberLabel.layer.cornerRadius = 6.9
        cell.numberLabel.layer.masksToBounds = true
        
        cell.numberLabel.layer.borderColor = UIColor.white.cgColor
        cell.numberLabel.layer.borderWidth = 1.0
        
        // Configure text color
        
        if order.status == "processing"{
            cell.statusLabel.textColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
        }else if order.status == "in progress"{
            cell.statusLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        }else if order.status == "picked up"{
            cell.statusLabel.textColor = UIColor(red: 36/255.0, green: 110/255.0, blue: 255/255.0, alpha: 1.0)
        }else if order.status == "washing"{
            cell.statusLabel.textColor = UIColor(red: 255/255.0, green: 82/255.0, blue: 111/255.0, alpha: 1.0)
        }

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        selectedAppointment = currentTransactionList[(indexPath as NSIndexPath).row ]
        
        selectedAppointment.printAppointment()
        
        if selectedAppointment.status == "processing" {
            self.performSegue(withIdentifier: "showOrderCheckin", sender: self)
        }else if selectedAppointment.status == "in progress"{
            self.performSegue(withIdentifier: "showPickupDetails", sender: self)
        }else if selectedAppointment.status == "picked up"{
            self.performSegue(withIdentifier: "showWashConfirm", sender: self)
        }else if selectedAppointment.status == "washing"{
            self.performSegue(withIdentifier: "showDropoffDetails", sender: self)
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "showOrderCheckin") {
            
            let detailVC = (segue.destination as! OrderCheckinViewController)
            detailVC.appointment = self.selectedAppointment
            detailVC.currentEmp = self.currentEmp
        }else if (segue.identifier == "showPickupDetails") {
            
            let detailVC = (segue.destination as! OrderPickupViewController)
            detailVC.appointment = self.selectedAppointment
            detailVC.currentEmp = self.currentEmp

        }else if (segue.identifier == "showWashConfirm") {
            
            let detailVC = (segue.destination as! OrderWashingViewController)
            detailVC.appointment = self.selectedAppointment
            detailVC.currentEmp = self.currentEmp

        }else if (segue.identifier == "showDropoffDetails") {
            
            let detailVC = (segue.destination as! OrderDropOffViewController)
            detailVC.appointment = self.selectedAppointment
            detailVC.currentEmp = self.currentEmp
        }else if (segue.identifier == "showEmpHistory") {
            
            let detailVC = (segue.destination as! EmpOrderHistoryViewController)
            detailVC.currentEmp = self.currentEmp
        }
        
    }
    
    
}
