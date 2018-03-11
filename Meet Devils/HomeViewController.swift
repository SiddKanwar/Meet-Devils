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
import FirebaseStorage
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let deviceId = UIDevice.current.identifierForVendor?.uuidString
    
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
            
            manageConnections(userId: uid)
            
            self.nameLabel.text = name
        
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://meet-devils.appspot.com")
            let profilePicRef = storageRef.child(user.uid + "/profile_pic.jpg")

            //check if the profile pic already exists in the firebase
            profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("image unable to download")
                } else {
                    // profile pic has been downloaded from firebase
                        self.profilePicture.image = UIImage(data: data!)

                    }
                }
            
            //if not, download it to firebase
            if(self.profilePicture.image == nil) {
          
            var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300 , "width":300 , "redirect":false], httpMethod: "GET")
            profilePic?.start(completionHandler: {(connection, result, error) -> Void in
                // Insert your code here
                if(error == nil) {
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    let urlPic = ((data as AnyObject).object(forKey: "url"))! as! String
                    
                    if let imageData = NSData(contentsOf: NSURL(string: urlPic)! as URL) {
                        let uploadTask = profilePicRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                            }
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            let downloadURL = metadata.downloadURL
                        }
                        self.profilePicture.image = UIImage(data:imageData as Data)
                    }
                }
            })

            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        //update the db for user is going offline
        let user = Auth.auth().currentUser
        let userID = user?.uid;

        let myConnectionRef = Database.database().reference(withPath: "user_profile/\(userID!)/connections/\(self.deviceId!)")
        
        //when the user logs out, set the value to false
        myConnectionRef.child("online").setValue(false)
        myConnectionRef.child("last-online").setValue(NSDate().timeIntervalSince1970)
        
        
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
    
    func manageConnections(userId: String) {
        //create a reference to the DB
        let myConnectionRef = Database.database().reference(withPath: "user_profile/\(userId)/connections/\(self.deviceId!)")
        //when the user logs in, set the value to true
        myConnectionRef.child("online").setValue(true)
        myConnectionRef.child("last-online").setValue(NSDate().timeIntervalSince1970)
        
        //observer will monitor if the user is logged in or not
        myConnectionRef.observe(DataEventType.value, with: { (snapshot) in
            
            //unlike an if statement, guard statements only run if the condition is not met
            guard let connected = snapshot.value as? Bool, connected else {
                // Uh-oh, an error occurred!
                return
            }
        })
        
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
