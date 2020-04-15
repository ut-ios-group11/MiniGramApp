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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var loginErrorView: UIView!
    @IBOutlet weak var loginErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.updateSystemToCurrentState()
        self.hideKeyboardWhenTappedAround()
        spinner.hidesWhenStopped = true
        spinner.roundCorners(4)
        loginButton.roundCorners(4)
        loginErrorView.roundCorners(4)
        hideError()
        emailTextField.underlined()
        passwordTextField.underlined()
        
        self.disableInteraction(true)
        UserData.shared.tryAutoSignIn(onError: { (error) in
            LogManager.logInfo(error)
            self.disableInteraction(false)
        }) {
            self.performSegue(withIdentifier: "toSignedIn", sender: self)
            self.disableInteraction(false)
        }
    }
    
    func showError(error: String) {
        loginErrorLabel.text = error
        loginErrorView.isHidden = false
    }
    
    func hideError() {
        loginErrorView.isHidden = true
        loginErrorLabel.text = ""
    }
    
    @IBAction func loginClick(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showError(error: "No Email/Password")
            return
        }
        
        guard !email.isEmpty else {
            showError(error: "Please Type Email")
            return
        }
        
        guard !password.isEmpty else {
            showError(error: "Please Type Password")
            return
        }
        
        disableInteraction(true)
        UserData.shared.signIn(email: email, password: password, onError: { (error) in
            LogManager.logError(error)
            self.showError(error: "Incorrect Email/Password")
            self.disableInteraction(false)
        }, onComplete: {
            LogManager.logInfo("Login Succesful")
            self.performSegue(withIdentifier: "toSignedIn", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideError()
    }
    
}
