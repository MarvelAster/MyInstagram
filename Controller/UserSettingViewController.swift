//
//  UserSettingViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/25/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class UserSettingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //refresh controller
    var refreshController = UIRefreshControl()
    
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var userstorageRef : StorageReference!
    var userRef : DatabaseReference!
    var curUserPosts : [String : String] = [:]
    var curUserPostIds : [String] = []
    var allposts : [UserPost] = []
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    //MARK: -CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.curUserPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSnapshotCollectionViewCell", for: indexPath) as! PostSnapshotCollectionViewCell
        FireBaseDataHandler.shareInstance.getPostBasedOnPostId(postId: self.curUserPostIds[indexPath.row] , completion: {
            (post) in
            
            
            self.allposts.append(post)
            for (_, userId) in self.allposts[indexPath.row].postDetai.likeby {
                if userId == Auth.auth().currentUser?.uid {
                    self.allposts[indexPath.row].postDetai.isLike = true
                }
            }
            
            
            FireBaseDataHandler.shareInstance.getImgFromPath(path: "PostImage/\(post.postId).jpeg", completion: {
                (img) in
                DispatchQueue.main.async {
                    cell.imgView.image = img
                }
            })
        })
        //cell.imgView.image = UIImage(named: "loading")
        return cell
        
    }
    //MARK: -CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CurUserPostViewController") as! CurUserPostViewController
        controller.puserImg = self.imgView.image
        controller.puserName = self.lbl.text
        let cell = collectionView.cellForItem(at: indexPath) as! PostSnapshotCollectionViewCell
        controller.ppostImg = cell.imgView.image
        controller.ptimeLbl = self.allposts[indexPath.row].postDetai.timestamp.timeElapsed
        controller.pdescriptionLbl = self.allposts[indexPath.row].postDetai.description
        controller.plike = String(self.allposts[indexPath.row].postDetai.like)
        controller.curpostId = self.allposts[indexPath.row].postId
        controller.isLike = self.allposts[indexPath.row].postDetai.isLike
        present(controller, animated: true, completion: nil)
    }
    
    
    //refresh controller
    @objc func refreshAction() {
        self.allposts = []
        self.curUserPostIds = []
        getCurUserPosts(completion: {
            () in
            //self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.posts.text = String(self.curUserPosts.count)
            }
            for (key, value) in self.curUserPosts {
                self.curUserPostIds.append(key)
            }
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
        })
    }
    //MARK: -InitialSetting
    func initialSetting() {
        setImg()
        setuserName()
        setuserImage()
    }
    func setImg() {
        self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.imgView.layer.borderWidth = 1.5
    }
    func setuserName () {
        FireBaseDataHandler.shareInstance.curUserName(completion: {
            (passname) in
            DispatchQueue.main.async {
                self.lbl.text = passname
            }
        })
    }
    func setuserImage() {
        FireBaseDataHandler.shareInstance.curUserImg(completion: {
            (img) in
            DispatchQueue.main.async {
                self.imgView.image = img
            }
        })
    }
    
    
    func getCurUserPosts(completion :@escaping () -> Void) {
        FireBaseDataHandler.shareInstance.curUserPosts(completion: {
            (posts) in
            self.curUserPosts = posts
            print(posts)
            print(self.curUserPosts)
            completion()
        })
    }
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 32, bottom: 20, right: 32)
        layout.itemSize = CGSize(width: 157, height: 151)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView!.collectionViewLayout = layout
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true

        //refresh controller
        refreshController.isEnabled = true
        refreshController.tintColor = UIColor.red
        refreshController.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        collectionView.addSubview(refreshController)
        
        userRef = Database.database().reference()
        userstorageRef = Storage.storage().reference()
        initialSetting()
        getCurUserPosts(completion: {
            () in
           self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.posts.text = String(self.curUserPosts.count)
            }
            for (key, value) in self.curUserPosts {
                self.curUserPostIds.append(key)
            }
            self.collectionView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        initialSetting()
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
