//
//  SubmitPostViewController.swift
//  MiniGram
//
//  Created by Joseph Manahan on 4/8/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class SubmitPostViewController: UIViewController {
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeSegue", sender: self)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
