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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        spinner.hidesWhenStopped = true
        spinner.roundCorners(4)
    }
    
    @IBAction func loginClick(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            LogManager.logError("No Email/Password")
            return
        }
        
        disableInteraction(true)
        UserData.shared.signIn(email: email, password: password, onError: { (error) in
            LogManager.logError(error)
            self.loginOutputLabel.text = "Login Error"
            self.disableInteraction(false)
        }, onComplete: {
            LogManager.logInfo("Login Succesful")
            if let name = UserData.shared.getDatabaseUser()?.name {
                self.loginOutputLabel.text = "\(name) was logged in"
            } else {
                self.loginOutputLabel.text = "NO NAME was logged in"
            }
            self.disableInteraction(false)
        })
    }
    
    func disableInteraction(_ bool: Bool) {
        let userInteraction = !bool
        
        emailTextField.isUserInteractionEnabled = userInteraction
        passwordTextField.isUserInteractionEnabled = userInteraction
        loginButton.isUserInteractionEnabled = userInteraction
        createAccountButton.isUserInteractionEnabled = userInteraction
        
        if bool {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    @IBAction func skipClick(_ sender: Any) {
        performSegue(withIdentifier: "toSignedIn", sender: self)
    }
    
    @IBAction func createAccountClick(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }
    
}
