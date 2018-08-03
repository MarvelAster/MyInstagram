//
//  FollowingViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/2/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendsCellDelegate {

    
    
    var friends : [UserInfo] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    func removeFriendWithUser(cell: FriendsTableViewCell) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.height/2
        cell.imgView.layer.borderColor = UIColor.black.cgColor
        cell.imgView.layer.borderWidth = 1.5
        cell.backgroundColor = UIColor(white : 1, alpha : 0.5)
        cell.nameLbl.text = friends[indexPath.row].user.Name
        FireBaseDataHandler.shareInstance.getImgFromPath(path: friends[indexPath.row].user.UserImage, completion: {
            (img) in
            DispatchQueue.main.async {
                cell.imgView.image = img
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CharWithFriendViewController") as! CharWithFriendViewController
        controller.friendId = friends[indexPath.row].userId
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        FireBaseDataHandler.shareInstance.getAllNeededUserInfo(catagray: "friends", completion: {
            (needUsers) in
            self.friends = needUsers
            self.tblView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView(frame: .zero)
        let backgroundImage = UIImage(named: "generalbackground")
        let imageView = UIImageView(image: backgroundImage)
        tblView.backgroundView = imageView
        FireBaseDataHandler.shareInstance.getAllNeededUserInfo(catagray: "friends", completion: {
            (needUsers) in
            self.friends = needUsers
            self.tblView.reloadData()
        })
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
