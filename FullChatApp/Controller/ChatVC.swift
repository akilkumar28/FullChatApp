//
//  ChatVC.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/24/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var chatTableView: UITableView!
    
    //MARK:- Properties
    
    
    //MARK:- Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Table view methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ChatCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    //MARK:- Function
    
    
    //MARK:- IBActions
    
    
}
