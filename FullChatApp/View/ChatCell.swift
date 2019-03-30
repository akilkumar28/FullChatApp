//
//  ChatCell.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/29/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var countView: UIView!
    
    //MARK:- Properties

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.countView.layer.cornerRadius = self.countView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- Functions
    
    
    func configureCell(recentChat:[String:Any]) {
        self.fullNameLabel.text = recentChat[kWITHUSERUSERNAME] as? String ?? "Error"
        self.lastMessageLabel.text = recentChat[kLASTMESSAGE] as? String ?? ""
        
        
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(pictureData: avatarString as! String) { (image) in
                if image == nil {
                    return
                }
                self.profilePicImageView.image = image?.circleMasked
            }
        }
        
        if recentChat[kCOUNTER] as! Int != 0 {
            self.countLabel.text = "\(recentChat[kCOUNTER] as! Int)"
            self.countView.backgroundColor = #colorLiteral(red: 1, green: 0.4412012994, blue: 0.4056814313, alpha: 1)
            self.countView.isHidden = false
            self.countLabel.isHidden = false
        } else{
            self.countView.isHidden = true
            self.countLabel.isHidden = true
        }
        
        var date:Date!
        
        if let created = recentChat[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        self.dateLabel.text = timeElapsed(date: date)
        
    }
    
    
    
    //MARK:- IBActions

}
