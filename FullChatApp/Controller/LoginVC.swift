//
//  LoginVC.swift
//  FullChatApp
//
//  Created by Akil Kumar Thota on 3/1/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    //MARK:- Properties
    
    
    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK:- Functions
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //MARK:- IBActions
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, email != "" else {
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            return
        }
        print(email,password)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
    }
    
}

