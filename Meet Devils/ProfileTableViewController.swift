//
//  ProfileTableViewController.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 3/9/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseCore
import Firebase
import FirebaseStorage
import FirebaseDatabase


class ProfileTableViewController: UITableViewController {

    var about = ["Name", "Gender", "Age", "Phone", "Email", "Website", "Bio"]
    
    //reference to Database
    var ref: DatabaseReference = Database.database().reference()


    var user = Auth.auth().currentUser
    
    @IBAction func didTapUpdate(_ sender: Any) {
        var index = 0
        
        while(index < about.count) {
            let indexPath = IndexPath(row:index, section:0)
            let cell:TextInputTableView? = self.tableView.cellForRow(at: indexPath) as! TextInputTableView
            
            if cell?.myTextField.text != "" {
                let item:String = (cell?.myTextField.text!)!
                
                switch about[index] {
                    case "Name":
                        self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(item)
                    case "Gender":
                        self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(item)
                    case "Age":
                        self.ref.child("user_profile").child("\(user!.uid)/age").setValue(item)
                    case "Phone":
                        self.ref.child("user_profile").child("\(user!.uid)/phone").setValue(item)
                    case "Email":
                        self.ref.child("user_profile").child("\(user!.uid)/email").setValue(item)
                    case "Website":
                        self.ref.child("user_profile").child("\(user!.uid)/website").setValue(item)
                    case "Bio":
                        self.ref.child("user_profile").child("\(user!.uid)/bio").setValue(item)
                default:
                    print("dont update")
                
                }
            }
            index += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


         self.tableView.contentInset = UIEdgeInsetsMake(20,0,0,0)
        
        //read data from database about user profile
        var refHandle = self.ref.child("user_profile").observe(DataEventType.value, with: { (snapshot) in
            
            let userDict = snapshot.value as? NSDictionary
            let userDetails = userDict?.object(forKey: self.user!.uid) as? NSDictionary
            // ...
            var index = 0
            
            while(index < self.about.count) {
                let indexPath = IndexPath(row:index, section:0)
                let cell:TextInputTableView? = self.tableView.cellForRow(at: indexPath) as! TextInputTableView
                
                let field:String = (cell?.myTextField.placeholder?.lowercased())!
                
                switch field{
                case "name":
                    cell?.configure(text: userDetails?.object(forKey: "name") as? String, placeholder: "Name")
                case "gender":
                    cell?.configure(text: userDetails?.object(forKey: "gender") as? String, placeholder: "Gender")
                case "age":
                    cell?.configure(text: userDetails?.object(forKey: "age") as? String, placeholder: "Age")
                case "phone":
                    cell?.configure(text: userDetails?.object(forKey: "phone") as? String, placeholder: "Phone")
                case "email":
                    cell?.configure(text: userDetails?.object(forKey: "email") as? String, placeholder: "Email")
                case "website":
                    cell?.configure(text: userDetails?.object(forKey: "website") as? String, placeholder: "Website")
                case "bio":
                    cell?.configure(text: userDetails?.object(forKey: "bio") as? String, placeholder: "Bio")
                default:
                    print("")
                }
                index += 1
            }

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TextInputTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath) as! TextInputTableView
        cell.configure(text: "" , placeholder: "\(about[indexPath.row ])")
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
