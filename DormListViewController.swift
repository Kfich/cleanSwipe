//
//  DormListViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/12/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit


protocol DormListViewControllerDelegate: class{
    
    func dormListDidFinishSelecting(_ selected:String)
}


class DormListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    // ========================================

    var delegate: DormListViewControllerDelegate?
    
    var dorms: [String] = ["Mahoney Residential College", "Stanford Residential College", "Hecht Residential College", "Pearson Residential College", "Eaton Residential College", "Red Road Commons", "UV 1", "UV 2", "UV 3", "UV 4", "UV 5", "UV 6", "UV 7"]
    var checked = [false, false, false, false, false, false, false, false, false, false, false, false, false] // Array equal to the number of cells in table
    var selectedBuilding = ""

    
    
    //IBOutlets
    // ========================================
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var dormListTableView: UITableView!
    
    
    // ========================================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dormListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       // self.delegate?.dormListDidFinishSelecting(["Hey", "Don", "Kevin", "Alex"])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TABLE VIEW DATA SOURCE AND DELEGATES
    
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dorms.count;
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell:UITableViewCell = self.dormListTableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
            
            if !checked[(indexPath as NSIndexPath).row] {
                cell.accessoryType = .none
            } else if checked[(indexPath as NSIndexPath).row] {
                cell.accessoryType = .checkmark
            }
            
            cell.textLabel?.text = self.dorms[(indexPath as NSIndexPath).row]

            
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            selectedBuilding = dorms[indexPath.row]
            checked = [false, false, false, false, false, false, false, false, false, false, false, false, false]
            self.dormListTableView.reloadData()
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    checked[(indexPath as NSIndexPath).row] = false
                } else {
                    cell.accessoryType = .checkmark
                    checked[(indexPath as NSIndexPath).row] = true
                }
            }
            
            
        }
    
    
    //IBActions
    // ========================================
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        
        delegate?.dormListDidFinishSelecting(selectedBuilding)
        
        self.presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            //print("bye")
            
        })
        
        
        
    }
    
    
 
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}











