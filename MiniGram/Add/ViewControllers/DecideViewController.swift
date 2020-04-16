//
//  PostViewController.swift
//  MiniGram
//
//  Created by Joseph Manahan on 3/16/20.
//  Copyright © 2020 Joseph Manahan. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var miniButton: UIButton!
    
    var delegate: UIViewController!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image ?? UIImage(named: "placeholder")
        postButton.roundCorners(4)
        miniButton.roundCorners(4)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostSegue",
            let controller = segue.destination as? SubmitPostViewController {
            controller.delegate = self
            controller.image = self.image ?? UIImage(named: "placeholder")
        }
        if segue.identifier == "AddSegue",
            let controller = segue.destination as? AddMiniatureViewController {
            controller.delegate = self
            controller.image = self.image ?? UIImage(named: "placeholder")
        }
    }

}
