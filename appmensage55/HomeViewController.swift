//
//  index.swift
//  appmensage55
//
//  Created by carlos on 30-07-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseStorage
import FirebaseDatabase


class HomeViewController: UIViewController {

    
    let devideId = UIDevice.current.identifierForVendor?.uuidString
    
    
   
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var nombreperfil: UILabel!
    
    @IBOutlet weak var fotoperfil: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.startAnimating()
        
        self.fotoperfil.layer.cornerRadius = self.fotoperfil.frame.size.width/2
        self.fotoperfil.clipsToBounds = true
        if let user = Auth.auth().currentUser{
            let name = user.displayName
            _ = user.email
            let uid = user.uid
            let photoURL = user.photoURL
            
            manageconnection(userId: uid)
            
            //let dataer =  NSData(contentsOf: photoURL!)
            //self.fotoperfil.image = UIImage(data: dataer! as Data)
            //self.fotoperfil.clipsToBounds = true
            
            
            self.nombreperfil.text = name
            
            // firebase storage
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://proyecto-2edeb.appspot.com")
            
            let profilepicref = storageRef.child(user.uid+"/profile_pic.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilepicref.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("no se descargo la imagen de firebase")
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: 
                    //data!)
                    if(data != nil){
                        print("el usuario tiene una imagen, no se cesita descargar de facebook")
                        self.activity.stopAnimating()
                        self.fotoperfil.image = UIImage(data: data!)
                        
                    }
                    
                }
            }
            
            if(self.fotoperfil.image == nil){
            
            var profilepic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":300,"redirect":false], httpMethod: "GET")
            profilepic?.start(completionHandler: {( connection,  result,  error) -> Void in
                
                
                // Handle the result
                
                if (error == nil){
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    let urlpic = ((data as AnyObject).object(forKey: "url"))! as! String
                    
                    if let imageData = NSData(contentsOf: NSURL(string:urlpic)! as URL){
                        let profilepicref = storageRef.child(user.uid+"/profile_pic.jpg")
                        let uploadTask = profilepicref.putData(imageData as Data,metadata:nil){ (metadata, error) in
                            if(error == nil){
                                
                                // size,content type or the download url
                                let downloadUrl = metadata!.downloadURL
                                
                            }else{
                                print("error in downloading image")
                            }
                            
                        }
                        self.activity.stopAnimating()
                        self.fotoperfil.image = UIImage(data: imageData as Data)
                    }
                }
            })
                
        }//end if
            
            
            
            
            
            
        }else{
            print("else")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signout(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        let myconnectionref = Database.database().reference(withPath: "user_profile/\(user!.uid)/connections/\(self.devideId!)")
        
        myconnectionref.child("online").setValue(false)
        myconnectionref.child("last_online").setValue(NSDate().timeIntervalSince1970)
        
        
        
        
        //sign out de firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        // sign out de facebook
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(HomeViewController, animated: true, completion: nil)
        
    }
    
    func manageconnection(userId: String){
        
        let myconnectionref = Database.database().reference(withPath: "user_profile/\(userId)/connections/\(self.devideId!)")
        
        myconnectionref.child("online").setValue(true)
        myconnectionref.child("last_online").setValue(NSDate().timeIntervalSince1970)
        
        myconnectionref.observe(.value, with: { snapshot in
            
            guard let connected = snapshot.value as? Bool, connected else{
                return
            }
        
        
        })
    }

}
