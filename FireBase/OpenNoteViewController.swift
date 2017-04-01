//
//  OpenNoteViewController.swift
//  FireNotes
//
//  Created by Tom Nam on 2017-03-31.
//  Copyright © 2017 tnam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OpenNoteViewController: UIViewController {
    @IBOutlet weak var NoteTV: UITextView!
    @IBOutlet weak var TitleTF: UITextField!
    
    var databaseRef: FIRDatabaseReference!
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        databaseRef = FIRDatabase.database().reference()
        TitleTF.text = note?.title
        NoteTV.text = note?.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveEditAction(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        databaseRef.child(uid!).setValue(["\(TitleTF.text!)": "1\(NoteTV.text!)"])
        
        _ = navigationController?.popViewController(animated: true)
    }
    //https://firebase.google.com/docs/database/ios/read-and-write
    
}
