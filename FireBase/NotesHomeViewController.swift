//
//  NotesHomeViewController.swift
//  FireNotes
//
//  Created by Tom Nam on 2017-03-30.
//  Copyright © 2017 tnam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class NotesHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var UIDLB: UILabel!
    
    var FBUID = FIRAuth.auth()?.currentUser
    var notesArray: [Note]?
    var databaseRef: FIRDatabaseReference!
    var notesDictionary: Dictionary<String, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.isHidden = false
        databaseRef = FIRDatabase.database().reference()
        notesTable.delegate = self
        notesTable.dataSource = self
        UIDLB.text = FBUID?.uid
        
        // need to change to populate the notesDictionary and keep observing
        retrieveNote()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveNote() {
        notesArray = [Note]()
        databaseRef.child(FBUID!.uid).observe(.value, with: {
            (snapshot) in
            let personsNotes = JSON(snapshot.value!)
            print(personsNotes)
            var numNotes = 0
            
            //person's Notes
            for (title, TypeText) in personsNotes {
                let both = TypeText.stringValue
                let text = both.substring(from: both.index(both.startIndex, offsetBy: 1))
                let type = both.substring(to: both.index(both.startIndex, offsetBy: 1))
                let newNote = Note(title: title, type: type, text: text)
                self.notesArray?.append(newNote)
                numNotes += 1
            }
            print(self.notesArray!.count)
            
            self.notesTable.reloadData()
        })
    }
    
    @IBAction func LogOffAction(_ sender: UIButton) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Navigation")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        cell.textLabel?.text = self.notesArray![indexPath.row].title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNote"
        {
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
        if segue.identifier == "OpenNote",
            let destination = segue.destination as? OpenNoteViewController,
            let tableIndex = notesTable.indexPathForSelectedRow?.row
        {
            print(tableIndex)
            print(notesArray![tableIndex].title)
            destination.note = notesArray?[tableIndex]
        }
    }
    //https://firebase.google.com/docs/database/ios/read-and-write
    
}
