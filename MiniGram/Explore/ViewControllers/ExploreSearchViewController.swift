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
    @IBOutlet weak var tableView: UITableView!
    
    var users = [GenericUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.underlined()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func updateUserList() {
        if let text = searchTextField.text {
            users = text.isEmpty ? [GenericUser]() : UserData.shared.getUserList().filter({ (user) -> Bool in
                guard let name = user.name else {
                    return false
                }
                return name.range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            tableView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateUserList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: Table View Data Source

extension ExploreSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! ExploreSearchTableViewCell
        let user = users[indexPath.row]
        
        cell.profileImage?.image = user.image ?? UIImage(named: "placeholder")
        user.downloadImageIfMissing {
            DispatchQueue.main.async {
                if tableView.hasRowAtIndexPath(indexPath: indexPath) {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        cell.nameLabel.text = user.name
        return cell
    }
}

// MARK: Table View Delegate

extension ExploreSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
}


