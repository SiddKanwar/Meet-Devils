//
//  UsersCollectionViewController.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 3/10/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "CollectionViewCell"

class UsersCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    var databaseRef:DatabaseReference  = Database.database().reference()
    var usersDict = NSDictionary()
    
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingView.startAnimating()
        self.databaseRef.child("user_profile").observe(DataEventType.value, with:
            { (snapshot) in
                self.usersDict = (snapshot.value as? NSDictionary)!

                for(userId, details) in self.usersDict {
                    
                    let img = (details as AnyObject).object(forKey: "profile_pic_small") as? String
                    let name = (details as AnyObject).object(forKey: "name") as? String
                    let firstName = name?.components(separatedBy: " ")[0]

                    self.userNamesArray.append(name!)
                    self.userImagesArray.append(img!)
                    self.collectionView?.reloadData()
                    self.loadingView.stopAnimating()
                }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.userImagesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let imageUrl = NSURL(string:userImagesArray[indexPath.row])
        let imageData = NSData(contentsOf: imageUrl! as URL )
    
        cell.userImage.image = UIImage(data: imageData! as Data)
        cell.userName.text = userNamesArray[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
