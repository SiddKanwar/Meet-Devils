//
//  HomeViewController.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 2/17/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseCore
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
        self.profilePicture.clipsToBounds = true
        
        //Get the current user object
        if let user = Auth.auth().currentUser {
            // User is signed in.
            let name = user.displayName;
            let email = user.email;
            let photoUrl = user.photoURL;
            let uid = user.uid;
            
            self.nameLabel.text = name
            let data = try? Data(contentsOf: photoUrl!)
            profilePicture.image = UIImage(data:data!)
        } else {
            // No User signed in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        //Log user out of firebase
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        //Log user out of Facebook
        FBSDKLoginManager().logOut()
        
        //return back to the login screen
        print("Log out button clicked")
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController:UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(viewController, animated: true, completion: nil)
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
