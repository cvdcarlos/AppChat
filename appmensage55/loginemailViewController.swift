//
//  loginemailViewController.swift
//  appmensage55
//
//  Created by carlos on 31-07-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class loginemailViewController: UIViewController {

    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var password_label: UILabel!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorlabel: UILabel!
    var isSignIn:Bool = true
    var timer = Timer()
    
    
    
    
    @objc func Hide() {
        errorlabel.isHidden = true
        //timer.invalidate()  //You can remove timer here.
    }
    
    func UnHide(){
        errorlabel.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        // Flip the boolean
        isSignIn = !isSignIn
        self.Hide()
        
        self.email_label.isHidden=false
        self.password_label.isHidden=false
        self.emailTextField.isHidden=false
        self.passwordTextField.isHidden=false
        self.signInButton.isHidden=false
        self.signInLabel.isHidden=false
        self.signInSelector.isHidden=false
        // Check the bool and set the button and labels
        if isSignIn {
            self.signInLabel.text = "Login"
            self.signInButton.setTitle("Login", for: .normal)
        }
        else {
            
            self.signInLabel.text = "Sign up"
            self.signInButton.setTitle("Sign up", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        // TODO: Do some form validation on the email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            // Check if it's sign in or register
            if isSignIn {
                // Sign in the user with Firebase
                
                
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    
                    // Check that user isn't nil
                    if user != nil {
                        
                        // User is found, go to home screen
                        self.email_label.isHidden=true
                        self.password_label.isHidden=true
                        self.emailTextField.isHidden=true
                        self.passwordTextField.isHidden=true
                        self.signInButton.isHidden=true
                        self.signInLabel.isHidden=true
                        self.signInSelector.isHidden=true
                        self.activity.startAnimating()
                        
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                    }
                        
                    else {
                        // Error: check error and show message
                        
                        self.errorlabel.text = "Error try again"
                        self.UnHide()
                        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loginemailViewController.Hide), userInfo: nil, repeats: false)
                        
                    }
                    
                })
                
            }
            else {
                // Register the user with Firebase
                
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if user != nil {
                        // User is found, go to home screen
                        
                        self.signInLabel.text = "Registered"
                        
                        
                    }
                    else {
                        // Error: check error and show message
                        self.errorlabel.text = "Error try again"
                        self.UnHide()
                        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loginemailViewController.Hide), userInfo: nil, repeats: false)
                    }
                    
                    
                })
                
                
            }
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    

}
