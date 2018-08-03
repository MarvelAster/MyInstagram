//
//  UserSettingDetailViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/25/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import Foundation
import GoogleSignIn
import FBSDKLoginKit
class UserSettingDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    

    @IBOutlet weak var tblView: UITableView!
    
    
    //MARK: -TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "UserSettingTableViewCell") as! UserSettingTableViewCell
        cell.textLabel?.text = "Reset Password"
        return cell
    }
    
    //MARK: -TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controller  = storyboard?.instantiateViewController(withIdentifier: "PasswordChangeViewController")
            present(controller!, animated: true, completion: nil)
        }
    }
    @IBAction func signoutClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
        let mainStoreBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoreBoard.instantiateViewController(withIdentifier: "LoginNav")
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
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
