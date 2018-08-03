//
//  AllUsersViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/26/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
class AllUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AllUserCellDelegate {
    
    
    
    
    var users : [UserInfo] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: -AllUserCellDelegate
    func addFriendWithUser(cell: AllUsersTableViewCell) {
        guard let indexPath = tblView.indexPath(for: cell) else {
            return
        }
        FireBaseDataHandler.shareInstance.addFriend(friendId : self.users[indexPath.row].userId){
            () in
        }
    }
    
    
    //MARK: -TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as! AllUsersTableViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.toplbl.text = users[indexPath.row].user.Name
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.height/2
        cell.imgView.layer.borderColor = UIColor.black.cgColor
        cell.imgView.layer.borderWidth = 1.5
        FireBaseDataHandler.shareInstance.getImgFromPath(path: users[indexPath.row].user.UserImage , completion: {
            (img) in
            DispatchQueue.main.async {
                cell.imgView.image = img
            }
        })
        return cell
    }
    
    //MARK: -ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        FireBaseDataHandler.shareInstance.getAllUserInfo(completion: {
            (users) in
            print(users)
            self.users = users
            self.tblView.reloadData()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView(frame: .zero)
        let backgroundImage = UIImage(named: "generalbackground")
        let imageView = UIImageView(image: backgroundImage)
        tblView.backgroundView = imageView
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
