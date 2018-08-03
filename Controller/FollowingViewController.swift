//
//  FollowingViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/2/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var friends : [UserInfo] = []
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
