//
//  UsersCollectionViewController.swift
//  appmensage55
//
//  Created by carlos on 08-08-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "CollectionViewCell"

class UsersCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var databaseRef = Database.database().reference()
    var usersDict = NSDictionary()
    
    //var userNamesArray = [String]()
    //var userImagesArray = [String]()

    
    var userArray = [AnyObject]()
    var loggedinuser: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedinuser = Auth.auth().currentUser
        
        
        
        
        
        self.activity.startAnimating()
        
        self.databaseRef.child("user_profile").observe(.value, with: { (snapshot) in
            
            self.usersDict = (snapshot.value as? NSDictionary)!
            
            for(userId,details) in self.usersDict{
                let img = (details as! UIFontDescriptor).object(forKey: UIFontDescriptor.AttributeName(rawValue: "profile_pic_small")) as! String
                let name = (details as! UIFontDescriptor).object(forKey: UIFontDescriptor.AttributeName(rawValue: "name")) as! String
                let firstName = name.components(separatedBy: " ")[0]
                let connections = (details as! UIFontDescriptor).object(forKey: UIFontDescriptor.AttributeName(rawValue: "connections")) as? NSDictionary
                
                
                for(deviceId,connection) in connections!{
                    if((connection as AnyObject).object(forKey: "online") as! Bool){
                        
                        (details as! UIFontDescriptor).setValue(true, forKey: "online")
                    }else{
                        
                    }
                    
                }
                
                if(self.loggedinuser?.uid != userId as? String){
                    (details as AnyObject).setValue(userId,forKey: "uId")
                    self.userArray.append(details as AnyObject)
                }
                
                
                //self.userImagesArray.append(img)
                //self.userNamesArray.append(firstName)
                self.collectionView?.reloadData()
                self.activity.stopAnimating()
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
        //return self.userImagesArray.count
        return self.userArray.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        /*let imageUrl = NSURL(string: userImagesArray[indexPath.row])
        let imageData = NSData(contentsOf: imageUrl! as URL)
        
        cell.userImage.image = UIImage(data: imageData! as Data)
        cell.userName.text = userNamesArray[indexPath.row]*/
        
        let imageURL = NSURL(string:self.userArray[indexPath.row]["profile_pic_small"] as! String)
        let imagedata = NSData(contentsOf: imageURL! as URL)
    
        cell.userImage.image = UIImage(data: imagedata! as Data)
        
        // border
        cell.userImage.layer.borderWidth = 1.5
        if(self.userArray[indexPath.row]["online"] as! Bool){
            cell.userImage.layer.borderColor = UIColor.green.cgColor
            
            
            
        }else{
            cell.userImage.layer.borderColor = UIColor.red.cgColor
        }
        
        let firstname = (self.userArray[indexPath.row]["name"] as? String)!.components(separatedBy: (" "))[0]
        // Configure the cell
        
        //update the name
        cell.userName.text = firstname
        
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
