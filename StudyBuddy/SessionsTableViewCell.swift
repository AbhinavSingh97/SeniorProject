//
//  SessionsTableViewCell.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/3/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit

class SessionsTableViewCell: UITableViewCell {
    var sessionDescription : String?
    var mainImage : UIImage?
    
    var sessionView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(sessionView)
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sessionView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive = true
        sessionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sessionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sessionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let sessionDescription = sessionDescription {
            sessionView.text = sessionDescription
        }
        if let image = mainImage {
            mainImageView.image = image
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
