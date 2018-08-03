//
//  PostViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/29/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol postDelegate {
    func passCurrentPost(post : UserPost)
}
class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var delegate : postDelegate?
    var passPost : UserPost!
    
    
    
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCurUserName(userpost : UserPost, completion: @escaping () -> Void) {
        FireBaseDataHandler.shareInstance.curUserName(completion: {
            (name) in
                FireBaseDataHandler.shareInstance.curUserImg(completion: {
                    (img) in
                    self.passPost.postDetai.name = name
                    self.passPost.postDetai.postUserImage = img
                    self.passPost.postDetai.description = self.textView.text
                    self.passPost.postDetai.postImage = self.imgView.image
                    self.passPost.postId = userpost.postId
                    self.delegate?.passCurrentPost(post: self.passPost)
                    completion()
                })
        })
    }
    
    @IBAction func postClick(_ sender: Any) {
        SVProgressHUD.show()
        
        FireBaseDataHandler.shareInstance.postCreate(str: self.textView.text!, image: self.imgView.image!, completion: {
            (userpost) in
            self.getCurUserName(userpost : userpost, completion: {
                    () in
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                })
            
        })
    }
    
    @IBAction func cameraClick(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        if imgPicker.sourceType == .camera {
            imgPicker.sourceType = .camera
        } else {
            imgPicker.sourceType = .photoLibrary
        }
        present(imgPicker, animated: true, completion: nil)
    }
    //MARK: -ImagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgView.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var postdetail = PostDetail(description: "", imageRef: "", like: 0, timestamp: NSDate().timeIntervalSince1970, userId: "", postImage: nil, postUserImage: nil, name: nil, isLike : false, likeby : ["nil" : "nil"], commentby : [:])
        passPost = UserPost(postId: "", postDetai: postdetail)
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
