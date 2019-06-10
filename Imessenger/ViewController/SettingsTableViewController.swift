//
//  SettingsTableViewController.swift
//  Imessenger
//
//  Created by Ambar Kumar on 05/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

   
    @IBAction func logoutButtonPressed(_ sender: Any) {
        FUser.logOutCurrentUser { (success) in
            if success {
                //show login
                self.showLogin()
            }
        }
    }
    
    func showLogin(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "welcome")
       
        self.present(mainView,animated: true,completion: nil)
    }
}
