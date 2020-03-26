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
        miniaturesView.isHidden = true
    }
    
    
    @IBAction func switchProfileViews(_ sender: UISegmentedControl) {
        // If gallery view is selected
        if sender.selectedSegmentIndex == 0 {
            // The alpha of an object is it's transparency. This is used to hide and show the correct views
            galleryView.isHidden = false
            miniaturesView.isHidden = true
        } else {
            galleryView.isHidden = true
            miniaturesView.isHidden = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
