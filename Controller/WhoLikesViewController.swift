//
//  WhoLikesViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/30/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class WhoLikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var allLikeUsers : [String : String]?
    var allUsers : [String] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumber() - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "WhoLikesTableViewCell") as! WhoLikesTableViewCell
        let imgPath = "UserImage/\(allUsers[indexPath.row]).jpeg"
        FireBaseDataHandler.shareInstance.getImgFromPath(path: imgPath, completion: {
            (img) in
            FireBaseDataHandler.shareInstance.getUserNameBasedOnUserId(userId: self.allUsers[indexPath.row], completion: {
                (name) in
                DispatchQueue.main.async {
                    cell.name.text = name
                }
            })
            DispatchQueue.main.async {
                cell.imgView.image = img
            }
        })
        
        return cell
    }
    func createUserArray() {
        for (key, userId) in self.allLikeUsers! {
            if key != "nil" {
                self.allUsers.append(userId)
            }
        }
    }
    func getNumber () -> Int{
        return (self.allLikeUsers?.count)!
    }
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView(frame: .zero)
        let backgroundImage = UIImage(named: "generalbackground")
        let imageView = UIImageView(image: backgroundImage)
        tblView.backgroundView = imageView
        print(self.allLikeUsers)
        print(getNumber())
        createUserArray()
        print(self.allUsers)
        self.tblView.reloadData()
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
