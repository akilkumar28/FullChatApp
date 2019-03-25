//
//  ContactCell.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/23/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    let tapGesture = UITapGestureRecognizer()
    
    
    var currentIndexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImage.isUserInteractionEnabled = true
        tapGesture.addTarget(self, action: #selector(avatarImageTapped))
        self.avatarImage.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(fUser: FUser,indexPath:IndexPath) {
        self.currentIndexPath = indexPath
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { (image) in
                self.avatarImage.image = image?.circleMasked
            }
        }
        self.fullNameLabel.text = fUser.fullname
        
    }
    
    @objc func avatarImageTapped() {
        
    }

}
