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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        oldPasswordTextField.underlined()
        newPasswordTextField.underlined()
    }
}
