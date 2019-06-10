//
//  UsersTableViewController.swift
//  Imessenger
//
//  Created by Ambar Kumar on 05/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class UsersTableViewController: UITableViewController, UISearchResultsUpdating {
   
    

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var allUsers : [FUser] = []
    
    var filteredUser : [FUser] = []
    var allUsersGrouped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.tableFooterView = UIView()
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        loadUsers(filter: kCITY)
   
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchController.isActive && searchController.searchBar.text != ""{
            return 1 
        }else{
            return allUsersGrouped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUser.count
        }else{
            let sectionTitle = self.sectionTitleList[section]
        
        let users = self.allUsersGrouped[sectionTitle]
            return users!.count
        }
    }
    
    //MARK: IBActions
    
    @IBAction func filterSegmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
        var user : FUser
        
         if searchController.isActive && searchController.searchBar.text != ""{
        user = filteredUser[indexPath.row]
         }else{
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGrouped[sectionTitle]
            
            user = users![indexPath.row]
        }
        

        // Configure the cell...
        cell.generateCellWith(fuser: allUsers[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         if searchController.isActive && searchController.searchBar.text != ""{
            return ""
         }else{
            return sectionTitleList[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
         if searchController.isActive && searchController.searchBar.text != ""{
         return nil
         }else{
            return self.sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    
    func loadUsers(filter : String){
        ProgressHUD.show()
        
        var query : Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()?.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()?.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        
        query.getDocuments{(snapshot,error) in
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGrouped = [:]
            
            if error != nil{
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else{
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty{
                for userDictionary in snapshot.documents{
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    
                    if fUser.objectId != FUser.currentId(){
                        self.allUsers.append(fUser)
                    }
                }
                //split to groups
                self.splitDataIntoSections()
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
            ProgressHUD.dismiss()
            
        }
    }
    
    //MARK: search result
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText : String, scope : String = "All"){
        filteredUser = allUsers.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
        
    }
    
    //MARK: Helper function
    fileprivate func splitDataIntoSections(){
        var sectionTitle : String = ""
        for i in 0..<self.allUsers.count{
            let currentUser = self.allUsers[i]
            
            let firstCharacter = currentUser.firstname.first!
            
            let firstCharString = "\(firstCharacter)"
            
            if firstCharString != sectionTitle{
                sectionTitle = firstCharString
                
                self.allUsersGrouped[sectionTitle] = []
                
                self.sectionTitleList.append(sectionTitle)
            }
            
            self.allUsersGrouped[firstCharString]?.append(currentUser)
        }
    }

    
}
