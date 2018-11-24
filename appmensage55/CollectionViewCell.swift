//
//  CollectionViewCell.swift
//  appmensage55
//
//  Created by carlos on 08-08-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.makeitround()
    }
    
    func makeitround(){
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
    }
}
