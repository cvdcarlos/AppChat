//
//  ViewController.swift
//  appmensage55
//
//  Created by carlos on 27-07-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseStorage
import FirebaseDatabase


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    //@IBOutlet weak var imageemail: UIImageView!
    //@IBOutlet weak var emailbutton: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var loginbutton: FBSDKLoginButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginbutton.isHidden=true
        //self.emailbutton.isHidden=true
        //self.imageemail.isHidden=true
        Auth.auth().addStateDidChangeListener{auth, user in
            
            if user != nil{
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarView")
                self.present(HomeViewController, animated: true, completion: nil)
    
            }else{
                
                self.loginbutton.readPermissions = ["public_profile", "email", "user_friends"]
                self.view.addSubview(self.loginbutton)
                self.loginbutton.delegate = self
                self.loginbutton.isHidden=false
                //self.emailbutton.isHidden=false
                //self.imageemail.isHidden=false
                
            }
        // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("logged in")
        self.loginbutton.isHidden=true
        //self.emailbutton.isHidden=true
        //self.imageemail.isHidden=true
        
        
        activity.startAnimating()
        if error != nil {
            
            self.loginbutton.isHidden=false
            //self.emailbutton.isHidden=false
            //self.imageemail.isHidden=false
            
            activity.stopAnimating()
        
        }else if(result.isCancelled){
            
            self.loginbutton.isHidden=false
            //self.emailbutton.isHidden=false
            //self.imageemail.isHidden=false
            
            activity.stopAnimating()
        }else{
        
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
            Auth.auth().signIn(with: credential) { (user, error) in
            // ...
                
                    print("connected to firebase")
                
                if(error == nil){
                    
                    let storage = Storage.storage()
                    let storageRef = storage.reference(forURL: "gs://proyecto-2edeb.appspot.com")
                    let profilepicRef = storageRef.child(user!.uid+"/profile_pic_small.jpg")
                    //store the userid
                    let userid = user?.uid
                    let databaseRef = Database.database().reference()
                
                    databaseRef.child("user_profile").child(userid!).child("profile_pic_small").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let profile_pic = snapshot.value as? String?
                        
                        if(profile_pic == nil){
                            if let imageData = NSData(contentsOf: user!.photoURL!){
                                let uploadTask = profilepicRef.putData(imageData as Data,metadata:nil){
                                    metadata,error in
                                    
                                    if(error == nil){
                                        let downloadURL = metadata!.downloadURL
                                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(downloadURL()!.absoluteString)
                                    }else{
                                        print("error en descargar imagen")
                                    }
                                }
                            }
                            databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                            databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/phone").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                            databaseRef.child("user_profile").child("\(user!.uid)/website").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/bio").setValue("")
                        }else{
                            print("user no se ha logeado antes")
                            
                        }
                    
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user log out")
    }


}

