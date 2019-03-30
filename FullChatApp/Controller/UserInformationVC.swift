//
//  UserInformationVC.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/25/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import ProgressHUD

class UserInformationVC: UITableViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var blockUserButton: UIButton!
    
    //MARK:- Properties
    
    var fUser:FUser?
    
    
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

       loadDataForUser()
    }
    
    
    
    //MARK:- Table view methods
    
    
        
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    //MARK:- Functions
    
    func loadDataForUser() {
        if fUser == nil {
            return
        }
        imageFromData(pictureData: fUser!.avatar) { (image) in
            self.profilePicImageView.image = image?.circleMasked
        }
        fullNameLabel.text = fUser!.fullname
        phoneNumberLabel.text = fUser!.phoneNumber
        checkBlockStatus()
    }
    
    func checkBlockStatus() {
        if fUser?.objectId != FUser.currentId() {
            phoneButton.isHidden = false
            messageButton.isHidden = false
            blockUserButton.isHidden = false
        } else {
            phoneButton.isHidden = true
            messageButton.isHidden = true
            blockUserButton.isHidden = true
        }
        let blockedUsers = FUser.currentUser()!.blockedUsers
        print(blockedUsers)
        print(fUser!.objectId)
        if blockedUsers.contains(fUser!.objectId) {
            blockUserButton.setTitle("Unblock User", for: .normal)
        } else {
            blockUserButton.setTitle("Block User", for: .normal)
        }
    }
    
    
    
    //MARK:- IBActions
    
    @IBAction func phoneButtonTapped(_ sender: Any) {
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        startPrivateChat(user1: FUser.currentUser()!, user2: fUser!)
    }
    
    @IBAction func blockUserButtonTapped(_ sender: Any) {
        ProgressHUD.show()
        var blockedUsers = FUser.currentUser()!.blockedUsers
        if blockedUsers.contains(fUser!.objectId) {
            let removedIndex = blockedUsers.index(of: fUser!.objectId)
            blockedUsers.remove(at: removedIndex!)
        } else {
            blockedUsers.append(fUser!.objectId)
        }
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: blockedUsers]) { (error) in
            ProgressHUD.dismiss()
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            self.checkBlockStatus()
        }
    }
    

}
