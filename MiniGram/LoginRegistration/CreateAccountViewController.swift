//
//  CreateAccountViewController.swift
//  MiniGram
//
//  Created by Matthew Ewing on 2/18/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var createAccountErrorView: UIView!
    @IBOutlet weak var createAccountErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        hideKeyboardWhenTappedAround()
        spinner.roundCorners(4)
        hideError()
        // Do any additional setup after loading the view.
        
        createAccountErrorView.roundCorners(4)
        submitButton.roundCorners(4)
        cancelButton.roundCorners(4)
        styleTextFields()
    }
    
    func showError(error: String) {
        createAccountErrorLabel.text = error
        createAccountErrorView.isHidden = false
    }
    
    func hideError() {
        createAccountErrorView.isHidden = true
        createAccountErrorLabel.text = ""
    }

    @IBAction func submitPressed(_ sender: Any) {
        guard !usernameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !nameTextField.text!.isEmpty else {
            showError(error: "Fill Out All Fields")
            return
        }
        disableUserInteraction(true)
        Database.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, name: nameTextField.text!, onError: { (error) in
            LogManager.logError(error)
            self.showError(error: "Error Creating User")
            self.disableUserInteraction(false)
        }) {
            UserData.shared.tryAutoSignIn(onError: { (error) in
                LogManager.logInfo(error)
                self.navigationController?.popViewController(animated: false)
                self.disableUserInteraction(false)
            }) {
                self.performSegue(withIdentifier: "toSignedIn", sender: self)
                self.disableUserInteraction(false)
            }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func disableUserInteraction(_ bool: Bool) {
        let userInteraction = !bool
        nameTextField.isUserInteractionEnabled = userInteraction
        usernameTextField.isUserInteractionEnabled = userInteraction
        emailTextField.isUserInteractionEnabled = userInteraction
        passwordTextField.isUserInteractionEnabled = userInteraction
        submitButton.isUserInteractionEnabled = userInteraction
        cancelButton.isUserInteractionEnabled = userInteraction
        
        if bool {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideError()
    }
    
    func styleTextFields() {
        nameTextField.underlined()
        usernameTextField.underlined()
        emailTextField.underlined()
        passwordTextField.underlined()
    }
}
