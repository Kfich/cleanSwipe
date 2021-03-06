//
//  PageCell.swift
//  audible
//
//  Created by Brian Voong on 9/1/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    
    var page: Page? {
        didSet {
            
            guard let page = page else {
                return
            }
            
            let imageName = page.imageName
            
            
            imageView.image = UIImage(named: imageName)
            
            let color = UIColor(white: 0.2, alpha: 1)
            
            if let fontHeader = UIFont(name: "Geomanist-Regular", size: 25) {
                
                if let fontString = UIFont(name: "Geomanist-Regular", size: 18) {
                    print("")
                    
                    let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: fontHeader, NSForegroundColorAttributeName: color])
                    
                    attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSFontAttributeName: fontString, NSForegroundColorAttributeName: color]))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let length = attributedText.string.characters.count
                    attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
                    
                    textView.attributedText = attributedText
                }
            }
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "HIYA HOW ARE YOU"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        
        textView.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeparatorView.anchorToTop(nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






