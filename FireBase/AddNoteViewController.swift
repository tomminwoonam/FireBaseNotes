//
//  AddNoteViewController.swift
//  FireNotes
//
//  Created by Tom Nam on 2017-03-30.
//  Copyright © 2017 tnam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var TitleTF: UITextField!
    @IBOutlet weak var NoteTF: UITextView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet weak var TextNoteView: UIView!
    
    var databaseRef: FIRDatabaseReference!
    var empty = true
    var notesDictionary: Dictionary<String, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        databaseRef = FIRDatabase.database().reference()
        NoteTF.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if empty == true {
            textView.text = nil
            textView.textColor = UIColor.black
            empty = false
        }
    }
    
    @IBAction func SaveNewAction(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        print(uid!)
        
        databaseRef.child(uid!).updateChildValues(["\(TitleTF.text!)": "1\(NoteTF.text!)"])
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //https://firebase.google.com/docs/database/ios/read-and-write
    //https://www.ioscreator.com/tutorials/segmented-control-tutorial-ios8-swift
    //http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
    
}
