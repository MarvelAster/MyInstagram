//
//  ViewController.swift
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
import FirebaseMessaging
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    let overlayTransitioningDelegate = OverlayTransitionDelegate()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func loginClick(_ sender: Any) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!, completion: {(result, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            } else {
                Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                self.present(controller!, animated: true, completion: nil)
            }
        })
        //for test only
//        Auth.auth().signIn(withEmail: "chuanqi1021@gmail.com", password: "hcq19891021", completion: {(result, error) in
//            if let err = error {
//                TWMessageBarManager().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
//            } else {
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
//                self.present(controller!, animated: true, completion: nil)
//            }
//        })
        //
    }
    
    func naviBarSetting() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    //network check
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarSetting()
        
        
        
//        print(Auth.auth().currentUser?.uid)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

