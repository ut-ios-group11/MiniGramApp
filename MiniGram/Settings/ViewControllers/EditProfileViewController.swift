//
//  EditProfileViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/3/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileImageView: UIImageView!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editUsernameTextField: UITextField!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editProfileImageView.roundCorners(editProfileImageView.frame.size.width / 2)
        styleTextFields()
        styleButtons()

        // NEED A WAY TO GET EMAIL OF USER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        editEmailTextField.placeholder = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if let user = UserData.shared.getDatabaseUser() {
            updateProfile(user: user)
            UserData.shared.setUserRefreshFunction(with: updateProfile(user:))
        }
    }
    
    func updateProfile(user: GenericUser) {
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.userName!
        editProfileImageView.image = user.image
        user.downloadImageIfMissing(onComplete: updateImage)
        editNameTextField.placeholder = user.name
        editUsernameTextField.placeholder = user.userName
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let controller = UIAlertController(
            title: nil, message: nil,
            preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(
            title: "Take Photo",
            style: .default,
            handler: nil))
        controller.addAction(UIAlertAction(
            title: "Choose from Library",
            style: .default,
            handler: nil))
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        var newName: String? = nil
        var newUsername: String? = nil
        if editNameTextField.text != "" {
            newName = editNameTextField.text
        }
        if editUsernameTextField.text != "" {
            newUsername = editUsernameTextField.text
        }
        Database.shared.updateProfile(name: newName, userName: newUsername, onError: { (Error) in
            LogManager.logError(Error)
        }) {
            LogManager.logInfo("Updated profile information.")
        }
    }
    
    
    func styleTextFields() {
        editNameTextField.underlined()
        editUsernameTextField.underlined()
        editEmailTextField.underlined()
    }
    
    func styleButtons() {
        saveChangesButton.roundCorners(4)
        deleteAccountButton.roundCorners(4)
    }
    
    func updateImage(image: UIImage?) {
        editProfileImageView.image = image
    }
}
