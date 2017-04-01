//
//  SignUpViewController.swift
//  FireNotes
//
//  Created by Tom Nam on 2017-03-30.
//  Copyright © 2017 tnam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    var databaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        databaseRef = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        
        if EmailTF.text == "" || self.PasswordTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: EmailTF.text!, password: PasswordTF.text!) {
                (user, error) in
                
                if error == nil {
                    print("You have sucessfully signed up")
                    
                    //create the user's note section
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    self.databaseRef.child(uid!).setValue(["Sample Text Note": "1Sample Text Note Text! :D"])
                    
                    //Goes to the notes home page.
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn")
                    self.present(vc!, animated:true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}
