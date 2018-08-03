//
//  CommentViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/31/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
   
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var text: UITextField!
    var postId : String!
    var comments  : [Comment] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.lbl.text = self.comments[indexPath.row].commentDetail.commentText
        cell.backgroundColor = UIColor(white : 1, alpha : 0.5)
        FireBaseDataHandler.shareInstance.getImgFromPath(path: "UserImage/\(self.comments[indexPath.row].commentDetail.userId).jpeg", completion: {
            (img) in
            DispatchQueue.main.async {
                cell.imgView.image = img
            }
        })
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.text.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sentBtnClick(_ sender: Any) {
        var curText = self.text.text!
        self.text.text! = ""
        FireBaseDataHandler.shareInstance.commentCreate(comment: curText, postId: self.postId, completion: {
            (curComment) in
                self.comments.append(curComment)
                self.tblView.reloadData()
        })
        
    }
    @objc func keyboardWillShow(_ notification : Notification) {
        if let usrInfo = notification.userInfo {
            if let keyboardSize = (usrInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                bottomConstraint.constant = 0
                bottomConstraint.constant += keyboardSize.height
                //                print(keyboardSize.height)
                //                print(btnBottomConstaint.constant)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(_ notification : Notification) {
        if let usrInfo = notification.userInfo {
            if let keyboardSize = (usrInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                bottomConstraint.constant -= keyboardSize.height
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.separatorStyle = .none
        tblView.tableFooterView = UIView(frame: .zero)
        let backgroundImage = UIImage(named: "generalbackground")
        let imageView = UIImageView(image: backgroundImage)
        tblView.backgroundView = imageView
        self.text.layer.borderWidth = 1.5
        self.text.layer.borderColor = UIColor.black.cgColor
        self.text.layer.cornerRadius = 5
        FireBaseDataHandler.shareInstance.getAllCommentForAPost(postId: self.postId, completion: {
            (comments) in
                self.comments = comments
                self.tblView.reloadData()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
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
