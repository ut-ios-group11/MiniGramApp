//
//  EditProfileViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/3/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imagePicker.delegate = self
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
        editEmailTextField.placeholder = UserData.shared.getUserEmail()
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        
        let controller = UIAlertController(
            title: nil, message: nil,
            preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(
            title: "Take Photo",
            style: .default) { (alertAction) in
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        controller.addAction(UIAlertAction(
            title: "Choose from Library",
            style: .default) { (alertAction) in
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        LogManager.logInfo("Completed image picker")
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            editProfileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        LogManager.logInfo("Cancelled image picker")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if editEmailTextField.text != "" {
            let controller = UIAlertController(title: "Password Required", message: "Please enter your password to change your email.", preferredStyle: .alert)
            controller.addTextField()
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            controller.addAction(cancelAction)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (alertAction) in
                Database.shared.updateEmail(email: self.editEmailTextField.text!, password: controller.textFields![0].text!, onError: { (error) in
                    LogManager.logError(error)
                }, onComplete: {
                    LogManager.logInfo("Updated email sucessfully.")
                    UserData.shared.getUserReloadedEmail(onComplete: { (email) in
                        self.editEmailTextField.placeholder = email
                        self.editEmailTextField.text = ""
                    })
                })
            }
            controller.addAction(submitAction)
            present(controller, animated: true)
        }
        
        var newName: String? = nil
        var newUsername: String? = nil
        if editNameTextField.text != "" {
            newName = editNameTextField.text
        }
        if editUsernameTextField.text != "" {
            newUsername = editUsernameTextField.text
        }
        Database.shared.updateProfile(name: newName, userName: newUsername, onError: { (error) in
            LogManager.logError(error)
        }) {
            LogManager.logInfo("Updated profile information sucessfully.")
            self.editNameTextField.text = ""
            self.editUsernameTextField.text = ""
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
