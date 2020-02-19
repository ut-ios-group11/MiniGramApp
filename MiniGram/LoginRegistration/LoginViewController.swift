//
//  LoginViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginOutputLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginClick(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            LogManager.logError("No Email/Password")
            return
        }
        
        UserData.shared.signIn(email: email, password: password, onError: { (error) in
            LogManager.logError(error)
            self.loginOutputLabel.text = "Login Error"
        }, onComplete: {
            LogManager.logInfo("Login Succesful")
            if let name = UserData.shared.getDatabaseUser()?.name {
                self.loginOutputLabel.text = "\(name) was logged in"
            } else {
                self.loginOutputLabel.text = "NO NAME was logged in"
            }
        })
    }
    
    @IBAction func skipClick(_ sender: Any) {
        performSegue(withIdentifier: "toSignedIn", sender: self)
    }
    
    @IBAction func createAccountClick(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }
    
}
