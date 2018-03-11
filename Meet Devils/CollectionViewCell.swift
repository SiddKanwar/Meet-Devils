//
//  CollectionViewCell.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 3/10/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeItRound()
    }
    
    func makeItRound() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
    }
}
