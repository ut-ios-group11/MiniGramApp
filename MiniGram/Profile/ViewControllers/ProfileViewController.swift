//
//  ProfileViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!

    @IBOutlet weak var profileViewSelector: UISegmentedControl!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var miniaturesView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.roundCorners(profileImage.frame.size.width / 2)
        galleryView.isHidden = false
        miniaturesView.isHidden = true
    }
    
    @IBAction func switchProfileViews(_ sender: UISegmentedControl) {
        // If gallery view is selected
        if sender.selectedSegmentIndex == 0 {
            galleryView.isHidden = false
            miniaturesView.isHidden = true
        } else {
            galleryView.isHidden = true
            miniaturesView.isHidden = false
        }
    }
}
