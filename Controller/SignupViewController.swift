//
//  SignupViewController.swift
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
class SignupViewController: UIViewController, UITextFieldDelegate {

    //MARK: -Properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    var userRef : DatabaseReference!
    var userstorageRef : StorageReference!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: -ButtonAction
    @IBAction func signupClick(_ sender: Any) {
        if self.password.text! != self.passwordConfirm.text! {
            TWMessageBarManager().showMessage(withTitle: "Error", description: "password not match", type: .error)
            return
        }
        Auth.auth().createUser(withEmail: emailId.text!, password: password.text!, completion: {(result, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            } else {
                if let fireUser = result?.user {
//                    let user = User(Name: self.name.text!, EmailId: self.emailId.text!, PhoneNumber: "", UserImage: "")
                    let userDict = ["Name" : self.name.text!, "EmailId" : self.emailId.text!, "PhoneNumber" : "", "UserImage" : ""]
                    self.userRef.child(fireUser.uid).updateChildValues(userDict, withCompletionBlock: {
                        (error, ref) in
                        
                    })
                }
                self.navigationController?.popToRootViewController(animated: true   )
            }
        })
    }
    @IBAction func signinClick(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userRef = Database.database().reference().child("user")
        self.userstorageRef = Storage.storage().reference()
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
