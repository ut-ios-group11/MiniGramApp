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
    @IBOutlet weak var followingLabel: UILabel!

    @IBOutlet weak var profileViewSelector: UISegmentedControl!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var miniaturesView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewInsideScrollView: UIView!
    @IBOutlet weak var followButtonSeparator: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var profileToDisplay: GenericUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.roundCorners(profileImage.frame.size.width / 2)
        galleryView.isHidden = false
        miniaturesView.isHidden = true
        viewInsideScrollView.bringSubviewToFront(settingsButton)
        setStyleForSegmentedControl()
        
        if profileToDisplay == nil {
            followButton.isHidden = true
            followButtonSeparator.isHidden = true
        } else {
            settingsButton.isHidden = true
        }
    }
    
    func setProfileToDisplay(_ user: GenericUser) {
        profileToDisplay = user
    }
    
    func updateImage() {
        profileImage.image = profileToDisplay?.image ?? UIImage(named: "placeholder")
    }
    
    func reloadProfile() {
        if let profileToDisplay = profileToDisplay {
            updateProfile(user: profileToDisplay)
        } else if let user = UserData.shared.getDatabaseUser() {
            updateProfile(user: user)
        }
    }
    
    func updateProfile(user: GenericUser) {
        profileImage.image = user.image ?? UIImage(named: "placeholder")
        nameLabel.text = user.name
        let count = user.following?.count ?? 0
        usernameLabel.text = "@" + user.userName!
        followingLabel.text = String(count)
        user.downloadImageIfMissing(onComplete: updateImage)
        updateFollowButton()
    }
    
    func updateFollowButton() {
        
        if let loggedInUser = UserData.shared.getDatabaseUser(), let profileToDisplay = profileToDisplay {
            if let following = loggedInUser.following, following.contains(profileToDisplay.id) {
                followButton.isSelected = true
            } else {
                followButton.isSelected = false
            }
        } else {
            followButton.isSelected = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        UserData.shared.setUserRefreshFunction(with: reloadProfile)
        if profileToDisplay != nil {
            UserData.shared.setUserListRefreshFunction(with: reloadProfile)
        }
        
        reloadProfile()
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
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        guard let userId = UserData.shared.getDatabaseUser()?.id else {
            return
        }
        
        guard let followId = profileToDisplay?.id else {
            return
        }
        
        if(!sender.isSelected) {
            Database.shared.followUser(currentUserId: userId, userToFollowId: followId, onError: { (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully followed \(followId)")
            }
        } else {
            Database.shared.unFollowUser(currentUserId: userId, userToUnFollowId: followId, onError: { (error) in
                LogManager.logError(error)
            }) {
                LogManager.logInfo("\(userId) successfully unFollowed \(followId)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GalleryViewController {
            vc.setUser(profileToDisplay ?? UserData.shared.getDatabaseUser())
        }
        if let vc = segue.destination as? MiniaturesTableViewController {
            vc.setUser(profileToDisplay ?? UserData.shared.getDatabaseUser())
        }
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
