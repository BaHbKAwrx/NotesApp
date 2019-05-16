//
//  NoteTableViewCell.swift
//  NotesApp
//
//  Created by Shmygovskii Ivan on 5/13/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configureWith(text: String, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy  HH:mm"
        
        self.noteTextLabel.text = text
        self.dateLabel.text = dateFormatter.string(from: date)
        
    }
    
}
