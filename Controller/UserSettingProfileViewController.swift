//
//  UserSettingProfileViewController.swift
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
import SVProgressHUD
class UserSettingProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    var userstorageRef : StorageReference!
    var userRef : DatabaseReference!
    var userImg : String? = ""
    
    //MARK: -HelpFunction
    func upLoadUserImage() {
        guard let userImg = self.imgView.image else {
            return
        }
        FireBaseDataHandler.shareInstance.uploadUserInfoAndImage(name : self.name.text!, email : self.emailAddress.text!, phone : self.phoneNumber.text!, image: userImg, complection: {
            () in
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        })
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
    
    //MARK: -ButtonAction
    @IBAction func selectImgClick(_ sender: Any) {
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
    @IBAction func doneBtnClick(_ sender: Any) {
            SVProgressHUD.show()
            upLoadUserImage()
    }
    //MARK: -InitialSetting
    func setImg() {
        self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.imgView.layer.borderWidth = 1.5
    }
    func setDefaultInfo() {
        setuserName()
        setuserEmail()
        setPhone()
    }

    
    func setuserImage() {
        FireBaseDataHandler.shareInstance.curUserImg(completion: {
            (img) in
            DispatchQueue.main.async {
                self.imgView.image = img
            }
        })
    }
    func setuserName () {
        FireBaseDataHandler.shareInstance.curUserName(completion: {
            (passname) in
            DispatchQueue.main.async {
                self.name.text = passname
            }
        })
    }
    func setuserEmail() {
        FireBaseDataHandler.shareInstance.curUserEmail(completion: {
            (passemail) in
            DispatchQueue.main.async {
                self.emailAddress.text = passemail
            }
        })
    }
    func setPhone() {
        FireBaseDataHandler.shareInstance.curUserPhone(completion: {
            (passphone) in
            DispatchQueue.main.async {
                self.phoneNumber.text = passphone
            }
        })
    }
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultInfo()
        userRef = Database.database().reference()
        userstorageRef = Storage.storage().reference()
        setImg()
        setuserImage()
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
