//
//  TransactionHistoryViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/17/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase
//import MBProgressHUD


class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties  
    // ======================================================
    
    var transactionList = [Appointment]()
    var transactionListReversed = [Appointment]()
    var selectedAppointment = Appointment ()
    var currentUser = User()
    
    
    let dateFormatter = DateFormatter()
    
    // IBOutlets
    // ======================================================
    
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        currentUser.printUser()
        
        // Register TransactionCell 
        
        historyTableView.register(UINib(nibName: "TransactionViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")

        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        // Query backend to retrieve array of Transactions for currentUser
        
        let ref2 = Firebase(url:"https://cleanswipe.firebaseio.com/orders")
        
        ref2?.queryOrdered(byChild: "order_date").observe(.value, with: { snapshot in
            
            
            for child in (snapshot?.children)! {
                
                let order = Appointment(snapshot: child as! FDataSnapshot)
                
                if order.customerId == self.currentUser.userId{
                    
                    let strTime = order.createdAt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let s = formatter.date(from: strTime)
                    order.sortDate = s
                    
                    self.transactionList.append(order)
                }
            }
            
            self.transactionList.sort(by: { $0.sortDate!.compare($1.sortDate! as Date) == ComparisonResult.orderedAscending })
            
            /*
            for trans in self.transactionList{
                print(trans.sortDate)
            }
            */
            self.transactionListReversed = self.transactionList.reversed()

            self.historyTableView.reloadData()
            loadingNotification.hide(animated: true)

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ===================================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Custom Methods
    // ===================================
    
    
    
    // TABLE VIEW DATA SOURCE AND DELEGATES
    // ===================================

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionViewCell
        
        let transaction = self.transactionListReversed[(indexPath as NSIndexPath).section]
        
        let strTime = transaction.orderDate
        /*dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s = dateFormatter.date(from: strTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let newDateString = dateFormatter.string(from: s!)*/
        
        cell.purchaseDateLabel.text = "Purchase date:"
        cell.dateLabel.text = strTime
        
        cell.amountLabel.text = "Total amount: \(transaction.price)"
        cell.amountLabel.textColor = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        selectedAppointment = transactionListReversed[(indexPath as NSIndexPath).section]
        self.performSegue(withIdentifier: "showOrderDetails", sender: self)
        
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "showOrderDetails") {
            
            let detailVC = (segue.destination as! TransactionDetailViewController)
            detailVC.appointment = self.selectedAppointment
            
            
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            //navigationItem.setHidesBackButton(true, animated: false)
            
            
            
        }
        
    }
    

}
