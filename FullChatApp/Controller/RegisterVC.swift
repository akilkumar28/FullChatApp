//
//  RegisterVC.swift
//  FullChatApp
//
//  Created by Akil Kumar Thota on 3/1/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import ProgressHUD


class RegisterVC: UIViewController {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    //MARK:- Properties
    
    
    
    //MARK:- Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func clearAllTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func registerUser(withEmail email:String,withPassword password:String) {
        ProgressHUD.show("Creating an account...")
        FUser.registerUserWith(email: email, password: password, firstName: "", lastName: "") { (error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.dismiss()
            self.clearAllTextFields()
            
        }
    }
    
    
    
    //MARK:- IBActions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        guard let email = emailTextField.text, email != "" else {
            ProgressHUD.showError("Email field cannot be empty")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            ProgressHUD.showError("Password field cannot be empty")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword != "" else {
            ProgressHUD.showError("ConfirmPassword field cannot be empty")
            return
        }
        if password != confirmPassword {
            ProgressHUD.showError("Passwords are not a match. Please make sure the password is same on both fields")
            return
        }
        registerUser(withEmail: email, withPassword: password)
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
