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
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: Text Field Delegate
extension ExploreSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        users = string.isEmpty ? [GenericUser]() : UserData.shared.exploreUsers.filter({ (user) -> Bool in
            guard let name = user.name else {
                return false
            }
            return name.range(of: string, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        tableView.reloadData()
        
        return true;
    }
}

// MARK: Table View Data Source

extension ExploreSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! ExploreSearchTableViewCell
        cell.profileImage?.image = users[indexPath.row].image
        cell.nameLabel.text = users[indexPath.row].name
        return cell
    }
}

// MARK: Table View Delegate

extension ExploreSearchViewController: UITableViewDelegate {
    
}


