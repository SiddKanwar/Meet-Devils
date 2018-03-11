//
//  ViewController.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 2/13/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FirebaseCore
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    var loginButton = FBSDKLoginButton()
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Firebase
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //user is signed in
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarControllerView")
                self.present(homeViewController, animated: true, completion: nil)
            } else {
                //no user signed in
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email"]
                self.loginButton.delegate = self
                self.view.addSubview(self.loginButton)
                self.loginButton.isHidden = false
            }
        }
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("user logged in")
        
        self.loginButton.isHidden = true
        loadingSpinner.startAnimating()
        
        if(error != nil) {
            //handle errors
            self.loginButton.isHidden = false
            loadingSpinner.stopAnimating()
            
        } else if(result.isCancelled) {
            //handle cancel event
            self.loginButton.isHidden = false
            loadingSpinner.stopAnimating()
            
        } else {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    // ...
                    return
                }
                // User is signed in
            print("user logged into Firebase")
            
            //When user logs in for the first time, store users' email and username on their profile page
            //also store the small version of their pic in the db and in storage
                if(error == nil) {
                    let storage = Storage.storage()
                    let storageRef = storage.reference(forURL: "gs://meet-devils.appspot.com")
                    let profilePicRef = storageRef.child((user?.uid)! + "/profile_pic_small.jpg")
                    
                    //store the userID
                    let userId = user?.uid
                    let databaseRef: DatabaseReference = Database.database().reference()
                    //read data from database
                    databaseRef.child("user_profile").child(userId!).child("profile_pic_small").observeSingleEvent(of: .value, with: { (snapshot) in
                        let profile_pic = snapshot.value as? String?
                    
                        if(profile_pic == nil) {
                            if let imageData = NSData(contentsOf: user!.photoURL!){
                                let uploadTask = profilePicRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
                                    guard let metadata = metadata else {
                                        // Uh-oh, an error occurred!
                                        return
                                    }
                                    // Metadata contains file metadata such as size, content-type, and download URL.
                                    let downloadURL = metadata.downloadURL
                                   databaseRef.child("user_profile").child(userId!).child("profile_pic_small").setValue(downloadURL()?.absoluteString)
                                }
                                
                            }
                        
                            databaseRef.child("user_profile").child("\(userId!)/name").setValue(user?.displayName)
                            databaseRef.child("user_profile").child("\(userId!)/gender").setValue("")
                            databaseRef.child("user_profile").child("\(userId!)/age").setValue("")
                            databaseRef.child("user_profile").child("\(userId!)/phone").setValue("")
                            databaseRef.child("user_profile").child("\(userId!)/email").setValue(user?.email)
                            databaseRef.child("user_profile").child("\(userId!)/website").setValue("")
                            databaseRef.child("user_profile").child("\(userId!)/bio").setValue("")
                        } else {
                            print("user has logged in earlier") 
                        }
                    })
                }
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user did logged out")
    }
    
}

