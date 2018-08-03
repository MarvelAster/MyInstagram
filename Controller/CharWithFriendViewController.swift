//
//  CharWithFriendViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/4/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class CharWithFriendViewController: UIViewController, UITableViewDataSource,UITextFieldDelegate {
   
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tblView: UITableView!
    var conversation : Conversation?
    var friendId : String?
    var conversationId : String?
    
    
    private lazy var notificationRef = Database.database().reference().child("notificationRequests")
    private lazy var conversationRef = Database.database().reference().child("conversations")
    
    @IBAction func sentBtnClick(_ sender: Any) {
        if textField.text != "" {
            let curUser = Auth.auth().currentUser!
            let conv = ["Sender ID": curUser.uid,
                        "Message": self.textField.text] as [String : Any]
            var convKey: String = ""
            if friendId! < curUser.uid{
                convKey = friendId! + curUser.uid
            }else {
                convKey = curUser.uid + friendId!
            }
            let convUpdates = ["\(convKey)/\(Int(NSDate().timeIntervalSince1970))": conv]
            conversationRef.updateChildValues(convUpdates)
            
            let notificationKey = notificationRef.childByAutoId().key
            let notification = ["message": textField.text!, "receiverId": friendId, "senderId": curUser.uid]
            
            let notificationUpdate = [notificationKey: notification]
            notificationRef.updateChildValues(notificationUpdate)
            self.conversation?.conversationDetail.append(ConversationDetail(timestamp: String(NSDate().timeIntervalSince1970), message: textField.text!, sendId: curUser.uid))
            tblView.reloadData()
            textField.text = ""
        } else {
            textField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getConversationId() {
        let curUserId = Auth.auth().currentUser?.uid
        if friendId! < curUserId!{
            conversationId = friendId! + curUserId!
        } else {
            conversationId = curUserId! + friendId!
        }
    }
    
    func conversationSortByTime(completion :@escaping () ->Void) {
        var array = (self.conversation?.conversationDetail.sorted(by: {
            (conversationDetail1, conversationDetail2) in
            if conversationDetail1.timestamp < conversationDetail2.timestamp {
                return true
            } else {
                return false
            }
        }))!
        self.conversation?.conversationDetail = array
        completion()
    }
    
    @objc func reloadTbl(notification : Notification) {
        FireBaseDataHandler.shareInstance.getCurConversation(conversationId : self.conversationId!) {
            (conversations) in
            self.conversation = conversations
            self.conversationSortByTime(completion: {
                () in
                self.tblView.reloadData()
//                let indexpath = IndexPath(row: (self.conversation?.conversationDetail.count)! - 1, section : 0)
//                self.tblView.scrollToRow(at: indexpath, at: .bottom, animated: true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTbl(notification:)), name: Constants.notificationName, object: nil)
        getConversationId()
        FireBaseDataHandler.shareInstance.getCurConversation(conversationId : self.conversationId!) {
            (conversations) in
            self.conversation = conversations
            self.conversationSortByTime(completion: {
                () in
                self.tblView.reloadData()
            })
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.conversation == nil {
            return 0
        }
        return (self.conversation?.conversationDetail.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ChatWithFriendTableViewCell") as! ChatWithFriendTableViewCell
        let cur = self.conversation?.conversationDetail[indexPath.row]
        cell.chatText.layer.cornerRadius = 8
        cell.chatText.layer.borderWidth = 0.5
        cell.chatText.clipsToBounds = true
        cell.backgroundColor = UIColor(white : 1, alpha : 0)
        cell.chatText.backgroundColor = UIColor.white
        if cur?.sendId == Auth.auth().currentUser?.uid {
            cell.chatText.backgroundColor = UIColor.green
            cell.leadingConstraint.constant = view.frame.width - 10 - cell.chatText.frame.width
        }
        cell.chatText.text = cur?.message
        return cell
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
