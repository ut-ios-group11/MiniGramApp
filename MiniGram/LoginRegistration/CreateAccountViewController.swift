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

    @IBAction func submitPressed(_ sender: Any) {
        guard !usernameTextField.text!.isEmpty || !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty || !firstNameTextField.text!.isEmpty || !lastNameTextField.text!.isEmpty else {
            statusLabel.text = "Ensure all fields are filled out."
            return
        }
        Database.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, onError: { (error) in
            LogManager.logError("Create User Field not filled out")
        }) {
            // try auto login here
            // if failed, send back to login screen
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
