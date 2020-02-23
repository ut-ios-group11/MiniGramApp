//
//  CreateAccountViewController.swift
//  MiniGram
//
//  Created by Matthew Ewing on 2/18/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        hideKeyboardWhenTappedAround()
        spinner.roundCorners(4)
        // Do any additional setup after loading the view.
    }

    @IBAction func submitPressed(_ sender: Any) {
        guard !usernameTextField.text!.isEmpty || !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty || !firstNameTextField.text!.isEmpty || !lastNameTextField.text!.isEmpty else {
            statusLabel.text = "Ensure all fields are filled out."
            return
        }
        disableUserInteraction(true)
        Database.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, onError: { (error) in
            LogManager.logError("Create User Field not filled out")
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
        firstNameTextField.isUserInteractionEnabled = userInteraction
        lastNameTextField.isUserInteractionEnabled = userInteraction
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

}
