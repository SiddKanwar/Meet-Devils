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
                
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user did logged out")
    }

}
    


