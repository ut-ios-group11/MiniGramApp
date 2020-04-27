//
//  SettingsViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/2/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

var accountSettings = ["Edit Profile", "Change Password"]

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accountTableView.delegate = self
        accountTableView.dataSource = self
        setUpSegmentedControl()
        logOutButton.roundCorners(4)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpSegmentedControl() {
        switch Theme.getCurrentTheme() {
        case .system:
            themeSegmentedControl.selectedSegmentIndex = 0
        case .dark:
            themeSegmentedControl.selectedSegmentIndex = 1
        case .light:
            themeSegmentedControl.selectedSegmentIndex = 2
        }
    }
    
    @IBAction func switchTheme(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Theme.setCurrentTheme(.system)
        case 1:
            Theme.setCurrentTheme(.dark)
        case 2:
            Theme.setCurrentTheme(.light)
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func logoutButton() {
        UserData.shared.signOut(onError: { (error) in
            LogManager.logError(error)
        }) {
            if let vc = self.view.window?.rootViewController as? UINavigationController {
                vc.popToRootViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editProfileCell = tableView.dequeueReusableCell(withIdentifier: "editProfileCell", for: indexPath as IndexPath)
        let row = indexPath.row
        editProfileCell.textLabel?.text = accountSettings[row]

        return editProfileCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "changePasswordSegue", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
