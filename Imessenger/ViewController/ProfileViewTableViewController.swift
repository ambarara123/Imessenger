//
//  ProfileViewTableViewController.swift
//  Imessenger
//
//  Created by Ambar Kumar on 10/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import UIKit

class ProfileViewTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    var user : FUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(user?.city)

        setupUI()
        
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        print("call button pressed \(user?.fullname)")
    }
    
    @IBAction func blockButtonPressed(_ sender: Any) {
       
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId){
            //need to check if it is correct using firstIndex of
            let index = currentBlockedIds.firstIndex(of: user!.objectId)!
            currentBlockedIds.remove(at: index)
            
        }else{
            currentBlockedIds.append(user!.objectId)
        }
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: currentBlockedIds]) { (error) in
            if error != nil{
                print("error: \(error?.localizedDescription)")
                return
            }
            self.updateBlockStatus()
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 3
        }
    }
    
    func setupUI(){
        if user != nil{
            self.title = "Profile"
            fullNameLabel.text = user?.fullname
            phoneNumberLabel.text = user?.phoneNumber
            
            updateBlockStatus()
            
            imageFromData(pictureData: user!.avatar) { (image) in
                if image != nil{
                    avatarImageView.image = image!.circleMasked
                }
            }
        }
    }

    func updateBlockStatus(){
        if user?.objectId != FUser.currentId(){
            blockButton.isHidden = false
            messageButton.isHidden = false
            callButton.isHidden = false
        }else{
            blockButton.isHidden = true
            messageButton.isHidden = true
            callButton.isHidden = true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId){
            blockButton.setTitle("Unblock user", for: .normal)
        }else{
            blockButton.setTitle("Block user", for: .normal)

        }
    }
}
