//
//  ChangePasswordViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/4/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
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
    
    
}
