//
//  PostViewController.swift
//  MiniGram
//
//  Created by Joseph Manahan on 3/16/20.
//  Copyright © 2020 Joseph Manahan. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var addMiniatureButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var createPostButton: UIButton!

    @IBAction func addMiniatureButton(sender: UIButton) {
        
    }
    
    @IBAction func postButton(sender:  UIButton) {
        
    }
    
    @IBAction func createPostButton(sender: UIButton) {
        createPostButton.isHidden = true
        addMiniatureButton.isHidden = true
        
        captionField.isHidden = false
        postButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.isHidden = true
        captionField.isHidden = true
        //captionField.underlined()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
