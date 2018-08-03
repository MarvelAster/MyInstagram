//
//  PasswordChangeViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/27/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import TWMessageBarManager
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class PasswordChangeViewController: UIViewController {
    @IBOutlet weak var originalPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    @IBAction func changePasswordClick(_ sender: Any) {
        FireBaseDataHandler.shareInstance.curUserPasswordChange(password: self.originalPassword.text!, newPassword: self.newPassword.text!, completion: {
            (error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                TWMessageBarManager().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
        })
    }
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
