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
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        styleTextFields()
        styleButtons()
        errorView.roundCorners(4)
        spinner.hidesWhenStopped = true
        hideError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideError()
    }
    
    func styleTextFields() {
        oldPasswordTextField.underlined()
        newPasswordTextField.underlined()
        confirmNewPasswordTextField.underlined()
    }
    
    func styleButtons() {
        saveChangesButton.roundCorners(4)
    }
    
    func showError(error: String) {
        errorLabel.text = error
        errorView.isHidden = false
    }
    
    func hideError() {
        errorView.isHidden = true
        errorLabel.text = ""
    }
    
    func disableUserInteraction(_ bool: Bool) {
        let userInteraction = !bool
        oldPasswordTextField.isUserInteractionEnabled = userInteraction
        newPasswordTextField.isUserInteractionEnabled = userInteraction
        confirmNewPasswordTextField.isUserInteractionEnabled = userInteraction
        
        if bool {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    @IBAction func submitPasswordChange(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text, let oldPassword = oldPasswordTextField.text, let confirmPassword = confirmNewPasswordTextField.text else {
            return
        }
        if newPassword == confirmPassword {
            disableUserInteraction(true)
            Database.shared.updateUserPassword(newPassword: newPassword, oldPassword: oldPassword, onError: { (error) in
                LogManager.logError(error)
                self.showError(error: "Old Password Incorrect")
                self.disableUserInteraction(false)
            }) {
                LogManager.logInfo("User Password Updated")
                self.navigationController?.popViewController(animated: true)
                self.hideError()
                self.disableUserInteraction(false)
            }
        } else {
            showError(error: "Passwords Do Not Match")
        }
    }
}
