//
//  CommentViewController.swift
//  MiniGram
//
//  Created by Matthew Ewing on 3/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var addCommentText: UITextField!
    
    @IBAction func buttonPressedAddComment(_ sender: Any) {
        
    }
    
    var post: GenericPost?
    var user: GenericUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshData() {
        
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
