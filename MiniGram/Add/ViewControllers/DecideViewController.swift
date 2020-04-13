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
    
    var delegate: UIViewController!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostSegue",
            let controller = segue.destination as? SubmitPostViewController {
            controller.delegate = self
            controller.image = self.image
        }
        //if segue.identifier == "AddSegue",
        //    let controller = segue.destination as? DecideViewController {
        //    controller.delegate = self
        //    controller.image = self.photoCaptureProcessor.image
        //}
    }

}
