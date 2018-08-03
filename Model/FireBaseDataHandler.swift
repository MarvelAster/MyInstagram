//
//  WebSericeHandler.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/26/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import Foundation
import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
final class FireBaseDataHandler {
    
    static let shareInstance = FireBaseDataHandler()
    private init (){}
    var userRef : DatabaseReference!
    var userstorageRef : StorageReference!
    var postRef : DatabaseReference!
    var commentRef : DatabaseReference!
    var conversationRef : DatabaseReference!

//    var curUser : User?
    
    func initialDataBaseAndStorage() {
        userRef = Database.database().reference().child("user")
        userstorageRef = Storage.storage().reference()
        postRef = Database.database().reference().child("post")
        commentRef = Database.database().reference().child("comment")
        conversationRef = Database.database().reference().child("conversations")
    }
    
    
    func getCurConversation(conversationId : String, completion:@escaping (Conversation) -> Void) {
        initialDataBaseAndStorage()
        conversationRef.child(conversationId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let value = snapshot.value as? Dictionary<String, Any> {
                var conversations : [ConversationDetail] = []
                for (time, conver) in value {
                    let converValue = conver as! Dictionary<String, String>
                    let conversationDetail = ConversationDetail(timestamp: time, message: converValue["Message"]!, sendId: converValue["Sender ID"]!)
                    conversations.append(conversationDetail)
                }
                let curConversation = Conversation(conversationId: conversationId, conversationDetail: conversations)
                completion(curConversation)
            }
        })
    }
    
    func addFriend(friendId : String, completion : @escaping () -> Void) {
        initialDataBaseAndStorage()
        userRef.child((Auth.auth().currentUser?.uid)!).child("friends").updateChildValues([friendId : "friend id"])
    }
    func setFollowingsAndFollowers(followingId : String, followerId : String, completion : @escaping () -> Void) {
        initialDataBaseAndStorage()
        userRef.child(followerId).child("following").updateChildValues([followingId : "following id"])
        userRef.child(followingId).child("followers").updateChildValues([followerId : "followers id"])
        completion()
    }
    
    func getUserNameBasedOnUserId(userId : String, completion:@escaping (String?) -> Void) {
        initialDataBaseAndStorage()
        self.userRef.child(userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            completion(value["Name"] as! String)
        })
    }
    func likeOrUnlikePost(postId : String) {
        initialDataBaseAndStorage()
        var hasLike = false
        guard let curUser = Auth.auth().currentUser else {return}
        let curUserId = curUser.uid
        self.postRef = self.postRef.child(postId)
        
        self.postRef.child("likeby").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let likeUserDict = snapshot.value as? [String : String] {
                for (key, likeUserId) in likeUserDict {
                    if likeUserId == curUserId {
                        hasLike = true
                        self.postRef.child("likeby/\(key)").removeValue()
                    }
                }
            }
            if !hasLike {
                let key = self.postRef.childByAutoId().key
                let like = [key : curUserId]
                self.postRef.child("likeby").updateChildValues(like)
            }
            self.postRef.child("likeby").observeSingleEvent(of: .value, with: {
                (snapshot) in
                let count = ((snapshot.value as? [String : String])?.count) ?? 0
                let updateLike = ["likes" : count - 1]
                self.postRef.updateChildValues(updateLike)
            })
        })
        
        
        
        
        
    }
    
    func getUserName(userPost : UserPost, completion : @escaping (String, String, String, String) -> Void) {
        initialDataBaseAndStorage()
        postRef = postRef.child(userPost.postId)
        print(userPost.postId)
        let postImg = "PostImage/\(userPost.postId).jpeg"
        print(postImg)
        postRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            let userId = value["userId"]
            let postDescription = value["description"]
            print(userId)
            let userImg = "UserImage/\(userId!).jpeg"
            self.userRef.child(userId as! String).observeSingleEvent(of: .value, with: {
                (snapshot1) in
                guard let value1 = snapshot1.value as? Dictionary<String, Any> else {
                    return
                }
                let userName = value1["Name"]
                print(userName!)
                completion(userName as! String, userImg, postImg, postDescription as! String)
                //get imge and pass data
                
            })
        })
        
    }
    
    func getPostBasedOnPostId(postId : String, completion :@escaping (UserPost) -> Void) {
        initialDataBaseAndStorage()
        postRef.child(postId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let dic = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            print(dic)
            let postDetail = PostDetail(description: dic["description"]! as! String, imageRef: dic["imageRef"]! as! String, like: dic["likes"]! as! Int, timestamp: dic["timestamp"]! as! Double, userId : dic["userId"]! as! String, postImage : nil, postUserImage : nil, name : nil, isLike : dic["isLike"]! as! Bool, likeby : (dic["likeby"] as? [String : String])!, commentby : (dic["commentby"] as? [String : String]) ?? [:])
            print(postDetail)
            let curPostInfo = UserPost(postId: postId, postDetai: postDetail)
            print(curPostInfo)
            completion(curPostInfo)
        })
    }
    func getAllCommentForAPost(postId : String, completion :@escaping ([Comment]) -> Void) {
        initialDataBaseAndStorage()
        postRef.child(postId).child("commentby").observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String , String> else {
                return
            }
            print(value)
            var comments : [Comment] = []
            let dispatchGroup = DispatchGroup()
            for (commentIdd, str) in value {
                print(commentIdd)
                dispatchGroup.enter()
                Database.database().reference().child("comment").child(commentIdd).observeSingleEvent(of: .value, with: {
                    (snapshot1) in
                    guard let value1 = snapshot1.value as? Dictionary<String , String> else {
                        return
                    }
                    let commentdetail = CommentDetail(userId: value1["userId"]!, postId: value1["postId"]!, commentText: value1["commentText"]!)
                    let getcomments = Comment(commentId: commentIdd, commentDetail: commentdetail)
                    comments.append(getcomments)
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completion(comments)
            })
            
        })

    }

    func getAllPost(completion :@escaping ([UserPost]) -> Void){
        initialDataBaseAndStorage()
        postRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            var posts : [UserPost] = []
            for item in value {
                print(item.key)
                let dic = item.value as? Dictionary<String, Any>
                let postImg = "PostImage/\(item.key).jpeg"
                let userImg = "UserImage/\(dic!["userId"]! as! String).jpeg"
                let curPost = PostDetail(description: dic!["description"]! as! String, imageRef: dic!["imageRef"]! as! String, like: dic!["likes"]! as! Int, timestamp: dic!["timestamp"]! as! Double, userId : dic!["userId"]! as! String, postImage : nil, postUserImage : nil, name : nil, isLike : dic!["isLike"]! as! Bool, likeby : (dic!["likeby"] as? [String : String])!, commentby : (dic!["commentby"] as? [String : String]) ?? [:])
                print(curPost)
                let curPostInfo = UserPost(postId: item.key, postDetai: curPost)
                posts.append(curPostInfo)
            }
            completion(posts)
        })
        
    }
    func createPostForUser(postId : String) {
        if let curUser = Auth.auth().currentUser{
            Database.database().reference().child("user").child(curUser.uid).child("posts").updateChildValues([postId : "postId"])
        }
    }
    
    func createCommentbyForPost(postId : String, commentId : String) {
        Database.database().reference().child("post").child(postId).child("commentby").updateChildValues([commentId : "commentId"])
    }
    func commentCreate(comment : String, postId : String, completion :@escaping (Comment) ->Void) {
        initialDataBaseAndStorage()
        let commentId = commentRef.childByAutoId().key
        if let curUser = Auth.auth().currentUser {
            let dict = ["postId" : postId, "userId" : curUser.uid , "commentText" : comment]
            let curComment = Comment(commentId: commentId, commentDetail: CommentDetail(userId: curUser.uid, postId: postId, commentText: comment))
            commentRef.child(commentId).updateChildValues(dict)
            completion(curComment)
        }
        self.createCommentbyForPost(postId: postId, commentId: commentId)
    }
    func postCreate(str : String, image : UIImage, completion :@escaping (UserPost) -> Void) {
        initialDataBaseAndStorage()
        let postKey = postRef.childByAutoId().key
        if let curUser = Auth.auth().currentUser {
            let data = UIImagePNGRepresentation(image)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imagename = "PostImage/\(postKey).jpeg"
            userstorageRef = userstorageRef.child(imagename)
            userstorageRef?.putData(data!, metadata : metadata, completion : {
                (meta, error) in
                if let err = error {
                    TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                } else {
                    print(meta!)
                }
                let postDict = ["description" : str, "imageRef" : "", "likes" : 0, "timestamp" : NSDate().timeIntervalSince1970 , "userId" : curUser.uid, "isLike" : false, "likeby" : ["nil" : "nil"]] as [String : Any]
                let curPost = UserPost(postId: postKey, postDetai: PostDetail(description: str, imageRef: "", like: 0, timestamp: NSDate().timeIntervalSince1970, userId: curUser.uid, postImage: nil, postUserImage: nil, name: nil, isLike: false, likeby: ["nil" : "nil"], commentby : [:]))
                self.postRef.child(postKey).updateChildValues(postDict, withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        TWMessageBarManager().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                    }
                    completion(curPost)
                })
                self.createPostForUser(postId: postKey)
            })
        }
    }
    func curUserPasswordChange(password : String, newPassword : String, completion :@escaping (Error?) ->Void) {
        let curUser = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (curUser?.email)!, password: password)
        curUser?.reauthenticate(with: credential, completion: {
            (error) in
            if error == nil {
                curUser?.updatePassword(to: newPassword) { (errror) in
                    completion(errror)
                }
            } else {
                completion(error)
            }
        })
        
    }
    func passwordResetWithEmail(email : String, completion :@escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: {
            (error) in
            if let err = error {
                completion(err)
            } else {
                print("reset password email has been sent")
                completion(nil)
            }
        })
    }
    func uploadUserInfoAndImage(name : String, email : String, phone : String, image : UIImage, complection :@escaping () -> Void) {
        initialDataBaseAndStorage()
        if let curUser = Auth.auth().currentUser {
            let data = UIImagePNGRepresentation(image)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imagename = "UserImage/\(String(describing: curUser.uid)).jpeg"
            userstorageRef = userstorageRef.child(imagename)
            userstorageRef?.putData(data!, metadata : metadata, completion : {
                (meta, error) in
                if let err = error {
                    TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                } else {
                    print(meta!)
                }
                let userDict = ["Name" : name, "EmailId" : email, "PhoneNumber" : phone, "UserImage" : imagename]
                self.userRef.child(curUser.uid).updateChildValues(userDict, withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        TWMessageBarManager().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                    }
                    complection()
                })
            })
        }
    }
    func getAllNeededUserInfo(catagray : String, completion :@escaping ([UserInfo]) -> Void) {
        initialDataBaseAndStorage()
        userRef.child((Auth.auth().currentUser?.uid)!).child(catagray).observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            var users : [UserInfo] = []
            let dispachgroup = DispatchGroup()
            for (key, catagrayId) in value {
                dispachgroup.enter()
                Database.database().reference().child("user").child(key).observeSingleEvent(of: .value, with: {
                    (snapshot1) in
                    guard let value1 = snapshot1.value as? Dictionary<String, Any> else {
                        return
                    }
                    let curUser = User(Name: value1["Name"]! as! String, EmailId: value1["EmailId"]! as! String, PhoneNumber: value1["PhoneNumber"]! as! String, UserImage: value1["UserImage"]! as! String, posts : (value1["posts"] as? [String : String]) ?? [:], following : (value1["following"] as? [String : String]) ?? [:], followers : (value1["followers"] as? [String : String]) ?? [:], friends : (value1["friends"] as? [String : String]) ?? [:])
                    print(curUser)
                    let curUserInfo = UserInfo(userId: key, user: curUser)
                    users.append(curUserInfo)
                    dispachgroup.leave()
                })
            }
            dispachgroup.notify(queue: DispatchQueue.main, execute: {
                completion(users)
            })
        })
    }
    func getAllUserInfo(completion :@escaping ([UserInfo]) -> Void) {
        initialDataBaseAndStorage()
        userRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            var users : [UserInfo] = []
            for item in value {
                print(item.key)
                if item.key == Auth.auth().currentUser?.uid{
                    continue
                }
                let dic = item.value as? Dictionary<String, Any>
                let curUser = User(Name: dic!["Name"]! as! String, EmailId: dic!["EmailId"]! as! String, PhoneNumber: dic!["PhoneNumber"]! as! String, UserImage: dic!["UserImage"]! as! String, posts : (dic!["posts"] as? [String : String]) ?? [:], following : (dic!["following"] as? [String : String]) ?? [:], followers : (dic!["followers"] as? [String : String]) ?? [:], friends : (dic!["friends"] as? [String : String]) ?? [:])
                print(curUser)
                let curUserInfo = UserInfo(userId: item.key, user: curUser)
                users.append(curUserInfo)
            }
            completion(users)
        })
    }
    
    
    func getcurUserInfo(completion :@escaping (User) -> Void) {
        initialDataBaseAndStorage()
        if let curUser = Auth.auth().currentUser{
            userRef.child(curUser.uid).observeSingleEvent(of: .value, with: {
                (snapshot) in
                guard let value = snapshot.value as? Dictionary<String, Any> else {
                    return
                }
                let name = value["Name"] as? String ?? ""
                let emailid = value["EmailId"] as? String ?? ""
                let phoneNumber = value["PhoneNumber"] as? String ?? ""
                let img = value["UserImage"] as? String ?? ""
                let posts = (value["posts"] as? [String : String]) ?? [:]
                let following = (value["following"] as? [String : String]) ?? [:]
                let followers = (value["follower"] as? [String : String]) ?? [:]
                let friends = (value["friends"] as? [String : String]) ?? [:]
                let user = User(Name: name, EmailId: emailid, PhoneNumber: phoneNumber, UserImage: img, posts : posts, following : following, followers : followers, friends : friends)
//                self.curUser = user
                completion(user)
            })
        }
    }
    func getImgFromPath(path : String , completion :@escaping (UIImage) ->Void) {
        initialDataBaseAndStorage()
        let imagename = path
        self.userstorageRef = self.userstorageRef.child(imagename)
        self.userstorageRef.getData(maxSize: 1024*1024*1024, completion: {(data, error) in
            if error != nil {
                completion(UIImage(named: "defaulUserImage")!)
            } else {
                let img = UIImage(data: data!)
                print(img!)
                completion(img!)
            }
        })
    }
    func curUserImg(completion : @escaping (UIImage) -> Void) {
        self.getcurUserInfo(completion: {
            (user) in
            let imagename = user.UserImage
            self.userstorageRef = self.userstorageRef.child(imagename)
            self.userstorageRef.getData(maxSize: 1024*1024*1024, completion: {(data, error) in
                if error != nil {
                    completion(UIImage(named: "defaulUserImage")!)
                } else {
                    let img = UIImage(data: data!)
                    print(img!)
                    completion(img!)
                }
            })
        })
    }
    func curUserName(completion : @escaping (String) -> Void) {
        self.getcurUserInfo(completion: {
            (user) in
                completion(user.Name)
        })
    }
    func curUserEmail(completion : @escaping (String) -> Void) {
        self.getcurUserInfo(completion: {
            (user) in
            completion(user.EmailId)
        })
    }
    func curUserPhone(completion : @escaping (String) -> Void) {
        self.getcurUserInfo(completion: {
            (user) in
            completion(user.PhoneNumber)
        })
    }
    func curUserPosts(completion : @escaping ([String:String]) -> Void) {
        self.getcurUserInfo(completion: {
            (user) in
            completion(user.posts)
        })
    }
    func signinAndCheckIfCurrentUserExist(userId : String, completion :@escaping (Bool) -> Void) {
        self.initialDataBaseAndStorage()
        userRef.child(userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            var result = false
            if let value = snapshot.value as? Dictionary<String, Any> {
                result = true
            }
            completion(result)
        })
    }
}
