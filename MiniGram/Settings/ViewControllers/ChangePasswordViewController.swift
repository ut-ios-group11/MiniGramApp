//
//  ChangePasswordViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextFields()
        styleButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func styleTextFields() {
        oldPasswordTextField.underlined()
        newPasswordTextField.underlined()
    }
    
    func styleButtons() {
        saveChangesButton.roundCorners(4)
    }
    
    @IBAction func submitPasswordChange(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text, let oldPassword = oldPasswordTextField.text else {
            return
        }
        if !newPassword.isEmpty {
            Database.shared.updateUserPassword(newPassword: newPassword, oldPassword: oldPassword, onError: { (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("User Password Updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    
}
