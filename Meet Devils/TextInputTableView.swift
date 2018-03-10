//
//  TextInputTableView.swift
//  Meet Devils
//
//  Created by Sidd Kanwar on 3/9/18.
//  Copyright © 2018 Sidd Kanwar. All rights reserved.
//

import Foundation
import UIKit

public class TextInputTableView:UITableViewCell {
    
    @IBOutlet weak var myTextField: UITextField!
    
    public func configure(text:String?, placeholder:String?) {
        self.myTextField.text = text
        self.myTextField.placeholder = placeholder
    }
}

