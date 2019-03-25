//
//  LoginVC.swift
//  FullChatApp
//
//  Created by Akil Kumar Thota on 3/1/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase


class LoginVC: UIViewController {
    
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK:- Properties
    
    
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            goToAppHome()
        }
        
    }
    
    
    //MARK:- Functions
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func clearAllTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    func loginUser(withEmail email:String,withPassword password:String) {
        ProgressHUD.show("Loging in...")
        FUser.loginUserWith(email: email, password: password) { (error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.dismiss()
            self.goToAppHome()
        }
    }
    
    
    func goToAppHome() {
        clearAllTextFields()
        

        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        // go to app
        
        let mainApplication = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        present(mainApplication, animated: true, completion: nil)
        
        
    }
    
    //MARK:- IBActions
    
    @IBAction func comingFromLogout(segue: UIStoryboardSegue) {
    
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        guard let email = emailTextField.text, email != "" else {
            ProgressHUD.showError("Email field cannot be empty")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            ProgressHUD.showError("Password field cannot be empty")
            return
        }
        loginUser(withEmail: email, withPassword: password)
    }

    
}

