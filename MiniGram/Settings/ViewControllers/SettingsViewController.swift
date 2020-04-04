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
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accountTableView.delegate = self
        accountTableView.dataSource = self
        darkModeToggle(darkModeSwitch)
    }
    
    @IBAction func darkModeToggle(_ sender: UISwitch) {
        if darkModeSwitch.isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
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
    }
}
