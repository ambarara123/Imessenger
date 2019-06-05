//
//  ViewController.swift
//  Imessenger
//
//  Created by Ambar Kumar on 02/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import UIKit
import ProgressHUD
class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //MARK: IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            loginUser()
            
        }else{
            ProgressHUD.showError("Email and password is missing")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""{
            
            if passwordTextField.text == confirmPasswordTextField.text{
                
            registerUser()
            }else{
                ProgressHUD.showError("password is not matching")
            }
            
        }else{
            ProgressHUD.showError("All fields are required")
        }
        
    }
    
    @IBAction func backgroundTapGesture(_ sender: Any) {
        print("background tapped")
        dismissKeyboard()
        
    }
    
    
    func dismissKeyboard()  {
        self.view.endEditing(false)
    }
    
    func cleanTextFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func loginUser(){
        ProgressHUD.show("Logging you in...")
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }else{
                self.gotoApp()
            }
            
        }
    }
    
    func registerUser(){
        
        dismissKeyboard()
        performSegue(withIdentifier: "welcomeToFinish", sender: self)
        cleanTextFields()
        
        
    }
    
    func gotoApp(){
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        
       
        //goto app
        let mainView = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinish"{
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
        }
    }
    
}

