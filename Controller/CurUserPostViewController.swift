//
//  CurUserPostViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/1/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class CurUserPostViewController: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var likeLbl: UILabel!
    var puserImg : UIImage!
    var puserName : String!
    var ppostImg : UIImage!
    var ptimeLbl : String!
    var pdescriptionLbl : String!
    var plike : String!

    var curpostId : String!
    var isLike : Bool!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBAction func likeClick(_ sender: Any) {
        if likeBtn.isSelected {
            self.likeLbl.text = String(Int(self.likeLbl.text!)! - 1)
        } else {
            self.likeLbl.text = String(Int(self.likeLbl.text!)! + 1)
        }
        self.likeBtn.isSelected = !likeBtn.isSelected
        FireBaseDataHandler.shareInstance.likeOrUnlikePost(postId: self.curpostId)
    }
    
    @IBAction func commentClick(_ sender: Any) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.postId = curpostId
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImg.image = puserImg
        userName.text = puserName
        postImg.image = ppostImg
        timeLbl.text = ptimeLbl
        descriptionLbl.text = pdescriptionLbl
        likeLbl.text = plike
        self.likeBtn.isSelected = self.isLike
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
