//
//  ViewController.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/13/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate{
    func didSelectItem(_ name:String,price:Double,pictureString:String)
}

class TableViewController: UITableViewController {
    var menuItems = MenuItems()
    
    var delegate:TableViewControllerDelegate! = nil
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        let row = (indexPath as NSIndexPath).row
        cell.menuItemDescLabel.text = menuItems.names[row]
        cell.show(menuItems.specials[row], for: menuItems.prices[row])
        cell.clothingIcon?.image = UIImage(named: menuItems.pictures[row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discount = 0.1
        let row = (indexPath as NSIndexPath).row
        let name = menuItems.names[row]
        var price = menuItems.prices[row]
        if menuItems.specials[row]{price *= (1.0 - discount)} //adjust for discount
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelectItem(name, price: price, pictureString: menuItems.pictures[row])
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75
        
    }
}
