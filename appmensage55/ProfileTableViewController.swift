//
//  ProfileTableViewController.swift
//  appmensage55
//
//  Created by carlos on 05-08-17.
//  Copyright © 2017 carlos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ProfileTableViewController: UITableViewController {
    
    var arr = ["Name","Gender","Age","Phone","Email","Website","Bio"]
    var ref = Database.database().reference()
    
    //var ref: DatabaseReference! = Database.database().reference()
    
    
    
    
    var user = Auth.auth().currentUser
    
    @IBAction func update(_ sender: Any) {
        var index = 0
        while index<arr.count{
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell: tableviewcell? = (self.tableView.cellForRow(at: indexPath) as! tableviewcell)
            
            
            
            if cell?.textfield.text != ""{
                let item:String = (cell?.textfield.text!)!
                
                switch arr[index]{
                case "Name":
                    self.ref.child("user_profile").child("\(user!.uid)/name").setValue(item)
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
            
            index+=1
        }

        
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)

        _ = self.ref.child("user_profile").observe(DataEventType.value, with: { (snapshot) in
            
            let  usersDict = snapshot.value as! NSDictionary
            print(usersDict)
            let userDetails = usersDict.object(forKey: self.user!.uid)
            
            
            var index = 0
            
            
            while index<self.arr.count{
                
                let indexPath = IndexPath(row: index, section: 0)
                let cell: tableviewcell? = (self.tableView.cellForRow(at: indexPath) as! tableviewcell)
                
                
                let field: String = (cell?.textfield.placeholder?.lowercased())!
                
                
                switch field{
                    case "name":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "name") as? String, placeholder: "Name")
                    case "gender":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "gender") as? String, placeholder: "Gender")
                    case "age":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "age") as? String, placeholder: "Age")
                    case "phone":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "phone") as? String, placeholder: "Phone")
                    case "email":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "email") as? String, placeholder: "Email")
                    case "website":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "website") as? String, placeholder: "Website")
                    case "bio":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "bio") as? String, placeholder: "Bio")
                        
                        
                    default: break
                       
                }
                    
                
                
                index+=1
            }

            
            // ...
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:tableviewcell = tableView.dequeueReusableCell(withIdentifier: "textinput", for: indexPath) as! tableviewcell

        // Configure the cell...
        cell.configure(text: "", placeholder: "\(arr[indexPath.row])")
        return cell
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }*/

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
