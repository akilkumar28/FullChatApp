//
//  ProfileVC.swift
//  FullChatApp
//
//  Created by Akil Kumar Thota on 3/1/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileVC: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var countryTextField: UITextField!
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    //MARK:- Properties
    
    var email:String = ""
    var password:String = ""
    var avatarImage:UIImage? = nil
    
    
    //MARK:- Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.image = UIImage(named: "avatarPlaceholder")
        clearAllTextFields()
        
    }
    
    
    //MARK:- Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func displayCancelAlert() {
        let alertVC = UIAlertController(title: "Are you sure you want to cancel?", message: "All your typed data will be lost!", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func clearAllTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
    
    func registerUser(withFname fName:String, withLname lName:String, withCountry country:String, withCity city:String, withPhone phoneNum:String) {
        ProgressHUD.show("Creating an account...")
        FUser.registerUserWith(email: email, password: password, firstName: fName, lastName: lName) { (error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.show("Finalizing...")
            if self.avatarImage == nil {
                imageFromInitials(firstName: fName, lastName: lName, withBlock: { [unowned self] (image) in
                    self.avatarImage = image
                })
            }
            let imageData = UIImageJPEGRepresentation(self.avatarImage!, 0.7)
            let imageDataString = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            let fullName = fName + " " + lName
            
            let userDict:[String:Any] = [
                kFIRSTNAME: fName,
                kLASTNAME : lName,
                kFULLNAME: fullName,
                kCOUNTRY: country,
                kCITY: city,
                kPHONE: phoneNum,
                kAVATAR: imageDataString ?? ""
            ]
            updateCurrentUserInFirestore(withValues: userDict, completion: { (error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                ProgressHUD.dismiss()
                self.goToAppHome()
            })
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
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        guard let fName = firstNameTextField.text, fName != "", containsOnlyLetters(input: fName) else {
            ProgressHUD.showError("Please make sure First name field is correct")
            return
        }
        guard let lName = lastNameTextField.text, lName != "", containsOnlyLetters(input: lName) else {
            ProgressHUD.showError("Please make sure Last name field is correct")
            return
        }
        guard let country = countryTextField.text, country != "" else {
            ProgressHUD.showError("Country field cannot be empty")
            return
        }
        guard let city = cityTextField.text, city != "" else {
            ProgressHUD.showError("City field cannot be empty")
            return
        }
        guard let phoneNum = phoneTextField.text, phoneNum != "" else {
            ProgressHUD.showError("Phone number field cannot be empty")
            return
        }
        self.registerUser(withFname: fName, withLname: lName, withCountry: country, withCity: city, withPhone: phoneNum)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        displayCancelAlert()
    }
    
}
