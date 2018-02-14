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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    var loginButton = FBSDKLoginButton()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Optional: Place the button in the center of your view.
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email"]
        self.loginButton.delegate = self
        
        self.view.addSubview(loginButton)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("user logged in")
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user did logged out")
    }

}

