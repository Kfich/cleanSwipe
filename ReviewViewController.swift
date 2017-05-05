//
//  ReviewViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking
import HCSStarRatingView

class ReviewViewController: UIViewController {

    // Properties
    // =====================================
    
    var appointment = Appointment()
    var review = Review()
    var ratingBar = HCSStarRatingView()

    var loadingNotification = MBProgressHUD()
    let green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    // IBOutlets
    // =====================================
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var ratingContainerView: UIView!
    
    @IBOutlet weak var ratingContainer2: UIView!
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureRatingView()
        appointment.printAppointment()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ====================================
    @IBAction func cancelReview(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitReview(_ sender: AnyObject) {
        
        // ***** NOTE ********
        
        // Check here if the user has actually input anything before submitting 
        // Also, format textview so the text is a placeholder -- All textviews 
        
        // ***** NOTE ********
        
        
        // Configure loading indicator
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Submitting review ..." 

        if (commentTextView.text != nil) {
            review.comment = commentTextView.text
        }
        
        let ref = Firebase(url: "https://cleanswipe.firebaseio.com/reviews")
        
        
        let reviewDict = ["transactionId" : appointment.transactionId,
                           "star_rating" : review.star_rating,
                           "comment" : review.comment] as [String : Any]
        
        print("==== The Review =====")
        print(reviewDict)
        
        
        ref?.child(byAppendingPath: self.appointment.transactionId).setValue(reviewDict)
        
        // Hide loading animator
        
        loadingNotification.hide(animated: true)

        // Dispatch push 
        dispatchPush()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // Custom Methods
    // ====================================
    
    func dispatchPush(){
        
        let m = Networking()
        m.genericPostCall("userId", deviceToken: AuthManager.sharedManager.deviceToken)
        print(AuthManager.sharedManager.deviceToken)
        print("Button hit")
    }
    
    func configureRatingView() {
        // Configure
        ratingBar.frame = CGRect(x: 0.0, y: 0.0, width: ratingContainerView.frame.width, height: 45.0)
        ratingBar.allowsHalfStars = false
        ratingBar.maximumValue = 13
        ratingBar.minimumValue = 0
        ratingBar.tintColor = green
    
        ratingBar.backgroundColor = UIColor.clear
        ratingBar.addTarget(self, action:#selector(ReviewViewController.ratingSelected), for: .touchUpInside)
        ratingContainerView.addSubview(ratingBar)
        
    }
    
    func configureRatingView2() {
        // Configure
        
    }
    
    
    func ratingSelected() {
        print("Rating selected")
        review.star_rating = Int(ratingBar.value)
        print(review.star_rating)
    }
    
    // Text view configuration 
    
    // Figure it out
    
    
    // Page Configuration 
    
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
