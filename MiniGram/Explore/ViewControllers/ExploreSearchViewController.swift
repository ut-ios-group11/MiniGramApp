//
//  ExploreSearchViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/27/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ExploreSearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
