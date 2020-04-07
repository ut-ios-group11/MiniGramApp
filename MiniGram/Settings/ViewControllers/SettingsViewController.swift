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
        darkModeSwitch.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        darkModeToggle(darkModeSwitch)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func darkModeToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        if darkModeSwitch.isOn {
            view.overrideUserInterfaceStyle = .dark
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            view.overrideUserInterfaceStyle = .light
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
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
    }
}
