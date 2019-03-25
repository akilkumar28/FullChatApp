//
//  SettingsVC.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/23/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class SettingsVC: UITableViewController {
    
    //MARK:- IBOutlets
    
    
    //MARK:- Properties
    
    
    //MARK:- Life Cycle Methods
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    
    //MARK:- Functions
    
    
    
    //MARK:- IBActions
    
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        ProgressHUD.show("Logging out..")
        FUser.logOutCurrentUser { (success) in
            if success {
                ProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToLoginScreen", sender: nil)
            } else {
                ProgressHUD.showError("Logout unsuccessfull")
            }
        }
    }
    
    

}
