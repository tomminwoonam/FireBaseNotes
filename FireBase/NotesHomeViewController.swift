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

class NotesHomeViewController:
    UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var UIDLB: UILabel!
    @IBOutlet weak var TitleSearchBar: UISearchBar!
    
    var FBUID = FIRAuth.auth()?.currentUser
    var notesArray: [Note]?
    var arrayToDisplay: [Note]?
    var databaseRef: FIRDatabaseReference!
    var notesDictionary: Dictionary<String, String>?
    let searchController = UISearchController(searchResultsController: nil)
    var searchedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.isHidden = false
        databaseRef = FIRDatabase.database().reference()
        notesTable.delegate = self
        notesTable.dataSource = self
        
        TitleSearchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
        // need to change to populate the notesDictionary and keep observing
        arrayToDisplay = [Note]()
        retrieveNote()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveNote() {
        databaseRef.child(FBUID!.uid).observe(.value, with: {
            (snapshot) in
            self.notesArray = [Note]()
            let personsNotes = JSON(snapshot.value!)
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
            
            self.arrayToDisplay = self.notesArray
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
        return self.arrayToDisplay!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        cell.textLabel?.text = self.arrayToDisplay![indexPath.row].title
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        arrayToDisplay = [Note]()
        if searchedTitle == "" {
            self.arrayToDisplay = self.notesArray
        } else {
            for element in notesArray! {
                print(element.title.lowercased())
                if element.title.lowercased().range(of: searchedTitle!) != nil {
                    arrayToDisplay?.append(element)
                }
            }
        }
        notesTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(for: searchController)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTitle = searchText.lowercased()
        updateSearchResults(for: searchController)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        TitleSearchBar.autocorrectionType = .no
        TitleSearchBar.autocapitalizationType = .none
        TitleSearchBar.spellCheckingType = .no
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
