//
//  HomeViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/29/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
extension HomeViewController : HomeTableViewDelegate {
    
    func postImgTapped(cell: HomeTableViewCell) {
        print("handling zoom tapped")
        let newImageView = UIImageView(image: cell.postImg.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        newImageView.addGestureRecognizer(tap)
        newImageView.addGestureRecognizer(pinchGesture)
        
        backgroundView = UIView(frame: (UIApplication.shared.keyWindow?.frame)!)
        backgroundView?.backgroundColor = .black
        backgroundView?.alpha = 1
        self.view.addSubview(backgroundView!)
        self.view.addSubview(newImageView)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        backgroundView?.alpha = 0
        sender.view?.removeFromSuperview()
    }
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1
    }
    func followBtnTapped(cell: HomeTableViewCell) {
        guard let indexPath = tblView.indexPath(for: cell) else {
            return
        }
        guard let curUser = Auth.auth().currentUser else {
            return
        }
        FireBaseDataHandler.shareInstance.setFollowingsAndFollowers(followingId : self.allPosts[indexPath.row].postDetai.userId, followerId : curUser.uid){
            () in
        }
    }
    
    func commentBtnTapped(cell: HomeTableViewCell) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
//        guard let indexPath = tblView.indexPath(for: cell) else {return}
        guard let indexPath = tblView.indexPath(for: cell) else {return}
        controller.postId = self.allPosts[indexPath.row].postId
        present(controller, animated: true, completion: nil)
    }
    
    func likeBtnTapped(cell: HomeTableViewCell) {
        var indexPath = tblView.indexPath(for: cell)!
        self.allPosts[indexPath.row].postDetai.isLike = !cell.likeBtn.isSelected
        if cell.likeBtn.isSelected {
            self.allPosts[indexPath.row].postDetai.like = self.allPosts[indexPath.row].postDetai.like - 1
            removeUserFromPost(indexPath: indexPath)
        } else {
            self.allPosts[indexPath.row].postDetai.like = self.allPosts[indexPath.row].postDetai.like + 1
            addUsertoPost(indexPath: indexPath)
        }
        
        tblView.reloadRows(at: [indexPath], with: .none)
        FireBaseDataHandler.shareInstance.likeOrUnlikePost(postId: self.allPosts[indexPath.row].postId)
    }
    func removeUserFromPost(indexPath : IndexPath) {
        for (key, userId) in self.allPosts[indexPath.row].postDetai.likeby {
            if userId == Auth.auth().currentUser?.uid {
                self.allPosts[indexPath.row].postDetai.likeby[key] = nil
            }
        }
    }
    
    func addUsertoPost(indexPath : IndexPath) {
        self.allPosts[indexPath.row].postDetai.likeby["currentUser"] = Auth.auth().currentUser?.uid
    }
    
    func likeCountTapped(cell: HomeTableViewCell) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "WhoLikesViewController") as! WhoLikesViewController
        guard let indexPath = tblView.indexPath(for: cell) else {return}
        controller.allLikeUsers = allPosts[indexPath.row].postDetai.likeby
        present(controller, animated: true, completion: nil)
    }
    
    
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, postDelegate {
    
    var backgroundView : UIView?
    
    
    var allPosts : [UserPost] = []
    let overlayTransitioningDelegate = OverlayTransitionDelegate()
    @IBOutlet weak var tblView: UITableView!
    //refresh controller
    var refreshController = UIRefreshControl()
    
    
    
    
    func likeClick(_ cell : HomeTableViewCell) {
        let indexPath = self.tblView.indexPath(for: cell)
        
    }
    
    //MARK: -TableViewDelegate
    
    
    //MARK: -postDelegate
    func passCurrentPost(post: UserPost) {
        self.allPosts.insert(post, at: 0)
        tblView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.delegate = self
        cell.postImg.image = UIImage(named: "loading")
        cell.userImg.image = UIImage(named: "defaulUserImage")
        cell.likeCount.text = String(allPosts[indexPath.row].postDetai.like)
        cell.likeBtn.isSelected = allPosts[indexPath.row].postDetai.isLike
        cell.timeLbl.text = allPosts[indexPath.row].postDetai.timestamp.timeElapsed
        if self.allPosts[indexPath.row].postDetai.name == nil || self.allPosts[indexPath.row].postDetai.postImage == nil || self.allPosts[indexPath.row].postDetai.postUserImage == nil {
            FireBaseDataHandler.shareInstance.getUserName(userPost: self.allPosts[indexPath.row], completion: {
                (name, userImg, postImg, postDescription) in
                self.allPosts[indexPath.row].postDetai.name = name
                DispatchQueue.main.async {
                    cell.username.text = name
                }
                DispatchQueue.main.async {
                    cell.descriptionLbl.text = postDescription
                }
                FireBaseDataHandler.shareInstance.getImgFromPath(path: postImg, completion: {
                    (pImg) in
                    self.allPosts[indexPath.row].postDetai.postImage = pImg
                    DispatchQueue.main.async {
                        cell.postImg.image = pImg
                    }
                })
                FireBaseDataHandler.shareInstance.getImgFromPath(path: userImg, completion: {
                    (uImg) in
                    self.allPosts[indexPath.row].postDetai.postUserImage = uImg
                    DispatchQueue.main.async {
                        cell.userImg.image = uImg
                    }
                })
                
            })
        } else {
            cell.username.text = self.allPosts[indexPath.row].postDetai.name
            cell.descriptionLbl.text = self.allPosts[indexPath.row].postDetai.description
            cell.postImg.image = self.allPosts[indexPath.row].postDetai.postImage
            cell.userImg.image = self.allPosts[indexPath.row].postDetai.postUserImage
        }
        return cell
    }
    func sortByTime() {
        self.allPosts = allPosts.sorted(by: {
            (post1, post2) in
            if post1.postDetai.timestamp > post2.postDetai.timestamp {
                return true
            } else {
                return false
            }
        })

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PostViewController {
            controller.delegate = self
        }
    }
    
    func getAllPostData(completion :@escaping () -> Void) {
        FireBaseDataHandler.shareInstance.getAllPost(completion: {
            (posts) in
                self.allPosts = posts
                self.sortByTime()
                //check if current user like post or not
                for index in 0 ..< self.allPosts.count {
                    for (key, userId) in self.allPosts[index].postDetai.likeby {
                        if userId == Auth.auth().currentUser?.uid {
                            self.allPosts[index].postDetai.isLike = true
                        }
                    }
                }
                completion()
            })
        }
    
    //refresh controller
    @objc func refreshAction() {
        getAllPostData(completion: {
            () in
            self.tblView.reloadData()
            self.refreshController.endRefreshing()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            return
        } else {
            print("Internet Connection not Available!")
            let controller = storyboard?.instantiateViewController(withIdentifier: "NetworkPopupViewController") as! NetworkPopupViewController
            controller.transitioningDelegate = self.overlayTransitioningDelegate
            controller.modalPresentationStyle = .custom
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.separatorStyle = .none
        tblView.tableFooterView = UIView(frame: .zero)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        let backgroundImage = UIImage(named: "generalbackground")
        let imageView = UIImageView(image: backgroundImage)
        tblView.backgroundView = imageView
        getAllPostData(completion: {
            () in
            self.tblView.reloadData()
        })
        
        //refresh controller
        refreshController.isEnabled = true
        refreshController.tintColor = UIColor.red
        refreshController.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tblView.addSubview(refreshController)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {

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
