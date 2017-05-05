//
//  PageItemController.swift
//  
//
//

import UIKit

class PageItemController: UIViewController {
    
    // MARK: - Properties
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    
    var screenShotImageName: String = "" {
        
        didSet {
            
            if let imageView = tutorialImage {
                imageView.image = UIImage(named: screenShotImageName)
            }
            
        }
    }
    
    var titleString: String = "" {
        
        didSet {
            
            if let label = titleLabel {
                label.text = titleString
            }
            
        }
    }
    
    var quote: String = "" {
        
        didSet {
            
            if let label = quoteLabel {
                label.text = quote
            }
            
        }
    }
    

    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var tutorialImage: UIImageView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize walkthrough content 
        
        contentImageView!.image = UIImage(named: imageName)
        titleLabel.text = titleString
        quoteLabel.text = quote
        tutorialImage!.image = UIImage(named: screenShotImageName)

        
    }
    
    

    
    
    
    
}
