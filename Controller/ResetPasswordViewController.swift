//
//  ResetPasswordViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/27/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBAction func sentEmailClick(_ sender: Any) {
        FireBaseDataHandler.shareInstance.passwordResetWithEmail(email: self.email.text!, completion: {
            (error) in
            if error == nil {
                let alter = UIAlertController(title: "Alter", message: "An email has been set to your email box, please check it ASAP", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            } else {
                let alter = UIAlertController(title: "Alter", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
        })
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
