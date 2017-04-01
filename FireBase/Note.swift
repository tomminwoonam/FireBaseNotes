//
//  Note.swift
//  FireNotes
//
//  Created by Tom Nam on 2017-03-31.
//  Copyright © 2017 tnam. All rights reserved.
//

import Foundation

class Note {
    var title:  String
    var type:   String
    var text:   String
    
    init(title: String, type: String, text: String) {
        self.title  = title
        self.type   = type
        self.text   = text
    }
    
}
