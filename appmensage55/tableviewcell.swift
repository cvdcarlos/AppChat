//
//  tableview.swift
//  appmensage55
//
//  Created by carlos on 05-08-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit

public class tableviewcell: UITableViewCell{
    
    
    @IBOutlet weak var textfield: UITextField!
    
    public func configure(text:String?,placeholder:String? ){
        textfield.text = text
        textfield.placeholder = placeholder
        
    }
    

}
