//
//  ProfileViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!

    @IBOutlet weak var profileViewSelector: UISegmentedControl!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var miniaturesView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var followButtonSeparator: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.roundCorners(profileImage.frame.size.width / 2)
        galleryView.isHidden = false
        miniaturesView.isHidden = true
        setStyleForSegmentedControl()
        
        // TODO: If user is current user, hide followButton and followButtonSeparator 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func setStyleForSegmentedControl() {
        let normalFont = UIFont.systemFont(ofSize: 16)
        let selectedFont = UIFont.boldSystemFont(ofSize: 16)

        profileViewSelector.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        profileViewSelector.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont], for: .selected)
        profileViewSelector.backgroundColor = .clear
        profileViewSelector.tintColor = .clear
        profileViewSelector.removeBorders()
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        if followButton.image(for: .normal) == UIImage(named: "follow_unselected") {
            followButton.setImage(UIImage(named: "follow_selected"), for: .normal)
        } else {
            followButton.setImage(UIImage(named: "follow_unselected"), for: .normal)
        }
        // TODO: Add user to follow list
    }
    
    
    
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  32.0, height: 32.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
