//
//  ContactsVC.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/23/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseFirestore

class ContactsVC: UITableViewController, UISearchResultsUpdating {
    
    
    
    
    
    //MARK:- IBOutlets

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    //MARK:- Properties
    var allUsers = [FUser]()
    var filteredUsers = [FUser]()
    var allUsersGrouped = [String:[FUser]]()
    var sectionTitleList = [String]()
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        loadUsers(withFilter: "All")

    }
    
    //MARK:- Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1

        } else {
            return allUsersGrouped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
            
        } else {
            let sectionTitle = sectionTitleList[section]
            let users = allUsersGrouped[sectionTitle]
            return users!.count
        }
    }
    
    //MARK:- Table view delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
            
        } else {
            return sectionTitleList[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
            
        } else {
            return sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactCell {
            var fUser: FUser
            if searchController.isActive && searchController.searchBar.text != "" {
                fUser = filteredUsers[indexPath.row]
            } else {
                let sectionTitle = sectionTitleList[indexPath.section]
                let users = allUsersGrouped[sectionTitle]
                fUser = users![indexPath.row]
            }
            cell.configureCell(fUser: fUser, indexPath: indexPath)
            return cell
        } else {
            return ContactCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- UISearchResultsUpdating Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(with: searchController.searchBar.text!)
    }
    
    //MARK:- Functions
    
    func filterContentForSearchText(with text:String, scope:String = "All") {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.fullname.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
    
    
    func loadUsers(withFilter filter:String) {
        ProgressHUD.show()
        
        var query: Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        
        allUsers = []
        allUsersGrouped = [:]
        sectionTitleList = []
        
        query.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
                ProgressHUD.showError("Error loading information")
                self.tableView.reloadData()
                return
            }
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty {
                for userDictionary in snapshot.documents {
                    let userDict = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDict)
                    
                    if fUser.objectId != FUser.currentUser()?.objectId {
                        self.allUsers.append(fUser)
                    }
                }
                
                self.splitDataIntoSections()
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
        
        
    }
    
    
    func splitDataIntoSections(){
        
        for i in 0..<allUsers.count {
            let currentUser = allUsers[i]
            let firstLetter = "\(currentUser.firstname.first!)"
            
            if allUsersGrouped.keys.contains(firstLetter) {
                allUsersGrouped[firstLetter]?.append(currentUser)
            } else {
                sectionTitleList.append(firstLetter)
                allUsersGrouped[firstLetter] = []
                allUsersGrouped[firstLetter]?.append(currentUser)
            }
        }
    }
    
    
    //MARK:- IBActions
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControll.selectedSegmentIndex == 0 {
            loadUsers(withFilter: "All")
        } else if segmentControll.selectedSegmentIndex == 1 {
            loadUsers(withFilter: kCOUNTRY)
        } else {
            loadUsers(withFilter: kCITY)
        }
    }
    


}
