//
//  SecondLoginViewController.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/25/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import TWMessageBarManager
import FacebookLogin
import FBSDKLoginKit
import FirebaseMessaging
class SecondLoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var fbloginBtn: FBSDKLoginButton!
    
    
   
    
    
    var userRef : DatabaseReference!
    var userstorageRef : StorageReference!
    @IBAction func googleSigninClick(_ sender: Any) {
        
       GIDSignIn.sharedInstance().signIn()
       //GIDSignIn.sharedInstance().signOut()
        

    }
    
    
    
    @IBAction func signinClick(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: -FacebookSignInDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let err = error {
            TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            print(err)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                print(err)
                return
            }
            FireBaseDataHandler.shareInstance.signinAndCheckIfCurrentUserExist(userId: (Auth.auth().currentUser?.uid)!, completion: {
                (result) in
                if result {
                    print("current user exist")
                } else {
                    print("current user not exist")
                    print(authResult?.user.displayName)
                    print(authResult?.user.providerID)
                    print(authResult?.user.uid)
                    print(authResult?.user.providerData[0].email)
                    print(authResult?.user.email)
                    let userDict = ["Name" : authResult?.user.displayName, "EmailId" : authResult?.user.providerData[0].email, "PhoneNumber" : "", "UserImage" : ""]
                    self.userRef.child((authResult?.user.uid)!).updateChildValues(userDict, withCompletionBlock: {
                        (error, ref) in
                    })
                }
                Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                self.present(controller!, animated: true, completion: nil)
            })
           
            //
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    //MARK: -GoogleSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error {
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            } else {
                FireBaseDataHandler.shareInstance.signinAndCheckIfCurrentUserExist(userId: (Auth.auth().currentUser?.uid)!, completion: {
                    (result) in
                    if result {
                        print("current user exist")
                    } else {
                        print("current user not exist")
                        if let fireUser = user {
                            print(fireUser.uid)
                            print(fireUser.displayName)
                            print(fireUser.email)
                            let userDict = ["Name" : fireUser.displayName, "EmailId" : fireUser.email, "PhoneNumber" : "", "UserImage" : ""]
                            self.userRef.child(fireUser.uid).updateChildValues(userDict, withCompletionBlock: {
                                (error, ref) in
                            })
                            //Messaging.messaging().subscribe(toTopic: fireUser.uid)
                            
                        }
                    }
                    Messaging.messaging().subscribe(toTopic: (Auth.auth().currentUser?.uid)!)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                    self.present(controller!, animated: true, completion: nil)
                })
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        self.userRef = Database.database().reference().child("user")
        self.userstorageRef = Storage.storage().reference()
        // Do any additional setup after loading the view.
        
        fbloginBtn.delegate = self
        fbloginBtn.readPermissions = ["public_profile", "email"]
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
