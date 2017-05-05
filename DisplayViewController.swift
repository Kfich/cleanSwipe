//
//  DisplayViewController.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/13/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import UIKit



class DisplayViewController: UIViewController, TableViewControllerDelegate, UITableViewDelegate,  UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // Properties
    // ======================
    
    
    // IBOutlets
    // ======================
    
    @IBOutlet weak var itemOrderedLabel: UILabel!
    @IBOutlet weak var cartDisplay: UITableView!
    @IBOutlet weak var PopupView: UIView!
    @IBOutlet weak var popPic: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var noItemsLabel: UILabel!
    
    
    
    
    // IBActions // Buttons Pressed
    
    @IBAction func proceed() {
        let totalNumOfItems = cart.count
        let totalCost = calculateTotal()
        
        self.showAlert("You have selected \(totalNumOfItems) items for a total of $\(totalCost)")
    }
    
    @IBAction func doneSelectingItems(_ sender: AnyObject) {
        
        if cart.count != 0 {
            
        
        // Set cart to manager
            AppointmentManager.sharedManager.cart = cart
        
        /*// Set price to += total
            // Set total price on appointment manager
            if AppointmentManager.sharedManager.userSelectedLaundry {
                AppointmentManager.sharedManager.appointment.price += calculateTotal()
            }else{
                AppointmentManager.sharedManager.appointment.price = calculateTotal()
            }*/
        
        //Set the items from the array to the appointment manager object
            AppointmentManager.sharedManager.appointment.items = cart as NSArray?
            
            // Set appointment manager has selected to true
        
            AppointmentManager.sharedManager.userSelectedDryCleaning = true
        
            // Dismiss viewcontroller
            self.presentingViewController?.dismiss(animated: true, completion: { () -> Void in
                //print("bye")
            
            })

        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "User Selected Service"), object: self)
        }
    }
    
    @IBAction func cancelOrder(_ sender: AnyObject) {
        
        print("\n\n\nAPT MANAGER NEW NEW SUBTRACTED PRICE")
        print(AppointmentManager.sharedManager.appointment.price)
        // Clear items in cart object and in manager object
        cart.removeAll()
        
        // Set to false on manager
        AppointmentManager.sharedManager.userSelectedDryCleaning = false
        
        // Dismiss view controller
        self.presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            //print("bye")
            
        })
        
    }
    
    
    
    @IBAction func cancelDryCleaning(_ sender: AnyObject) {
        
        
    }

    
    // Properties
    // =======================
    
    var cart : [selectedItem] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Inherit cart object 
        self.cart = AppointmentManager.sharedManager.cart
        // Calculate total
        updateTotal()
        
        
        PopupView.isHidden = true
        PopupView.layer.cornerRadius = 5;
        PopupView.layer.masksToBounds = true
        
        
        if self.cart.count == 0 {
            noItemsLabel.isHidden = false
        }else{
            noItemsLabel.isHidden = true
        }
        //        self.cartDisplay.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Custom Methods
    
    func calculateTotal() -> Double {
        let size = cart.count
        var total : Double = 0.0
        for i in 0 ..< size{
            total += (cart[i].price * Double(cart[i].num))
        }
        
        return total
    }
    
    func updateTotal() {
        
        let total = calculateTotal()
        
        
        print("\n\n\nAPT MANAGER NEW NEW PRICE")
        print(AppointmentManager.sharedManager.appointment.price)
        let price = String(format:"%2.2f", total)
        title = "Total: $" + price
        navBar.topItem?.title = title
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Hey AppCoda", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func didSelectItem(_ name: String, price: Double, pictureString: String) {
        
        noItemsLabel.isHidden = true
        
        _ = String(format:"Price: %02.2f", price)
        
        let selected : selectedItem = selectedItem(nameInput: name, priceInput: price, pictureString: pictureString)
        
        // search for existing item
        var found : Bool = false
        var foundIndex : Int?
        
        for i in 0 ..< cart.count {
            if cart[i].name == name {
                found = true
                foundIndex = i
                cart[foundIndex!].num += 1
            }
        }
        
        
        if !found {
            cart.append(selected)
            //        self.cartDisplay.beginUpdates()
            //        let totalIngredients = cart.count
            //        let newItemIndexPath = NSIndexPath(forRow: totalIngredients-1, inSection: 0)
            //        self.cartDisplay.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            //        self.cartDisplay.endUpdates()
            self.updateTotal()
            popPic.image = UIImage(named: pictureString)
            PopupView.isHidden = false
            PopupView.alpha = 1.0
            collectionView.reloadData()
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DisplayViewController.update), userInfo: nil, repeats: false)
            
        }
            
        else {
            
            self.updateTotal()
            //            self.cartDisplay.reloadData()
            popPic.image = UIImage(named: pictureString)
            PopupView.isHidden = false
            PopupView.alpha = 1.0
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DisplayViewController.update), userInfo: nil, repeats: false)
            collectionView.reloadData()
            
        }
    }
    
    func deleteUser(_ sender:UIButton) {
        
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        cart.remove(at: i)
        collectionView.reloadData()
        //var cost = calculateTotal()
        updateTotal()
        // Update manager cart too
        AppointmentManager.sharedManager.cart = cart
    }
    
    func update() {
        //  PopUpView.hidden = true
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.PopupView.alpha = 0.0
            }, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "table" {
            let vc = segue.destination as! TableViewController
            vc.delegate = self
        }
        
        
    }
    
    
    // TableView Delegate and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! CartTableViewCell
        let row = (indexPath as NSIndexPath).row
        cell.itemName.text = cart[row].name
        let price = String(format:"%2.2f", cart[row].price)
        cell.priceLabel.text = price
        cell.imageIcon.image = UIImage(named: cart[row].picture)
        cell.numOfItem.text = "x\(cart[row].num)"
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            cart.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
            // handle delete (by removing the data from your array and updating the tableview)
        }
        
    }
    
    // Collection View Delegate and Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cart.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if cart.count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: collectionView.frame.height, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "I'am a test label"
            self.view.addSubview(label)
            //self.collectionView.bringSubview(toFront: label)
        }
        
        cell.clothingLabel?.text = cart[(indexPath as NSIndexPath).row].name
        _ = String(format:"%2.2f", cart[(indexPath as NSIndexPath).row].price)
        cell.image?.image = UIImage(named: cart[(indexPath as NSIndexPath).row].picture)
        cell.num?.text = "x\(cart[(indexPath as NSIndexPath).row].num)"
        cell.xButton?.layer.setValue((indexPath as NSIndexPath).row, forKey: "index")
        cell.xButton?.addTarget(self, action: #selector(DisplayViewController.deleteUser(_:)), for: UIControlEvents.touchUpInside)
        //        cell.layer.borderWidth = 1.0
        //        cell.layer.borderColor = UIColor.grayColor().CGColor
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
