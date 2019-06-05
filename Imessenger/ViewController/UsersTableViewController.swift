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

        loadUsers(filter: kCITY)
   
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allUsers.count
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

        // Configure the cell...
        cell.generateCellWith(fuser: allUsers[indexPath.row], indexPath: indexPath)
        

        return cell
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
    

}
