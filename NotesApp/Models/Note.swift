//
//  Note.swift
//  NotesApp
//
//  Created by Shmygovskii Ivan on 5/13/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation

final class Note: NSObject, Codable {
    
    var text: String
    var date = Date()
    
    init(text: String) {
        self.text = text
    }
    
}
