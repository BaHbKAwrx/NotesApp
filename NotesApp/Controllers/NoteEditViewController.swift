//
//  NoteEditViewController.swift
//  NotesApp
//
//  Created by Shmygovskii Ivan on 5/13/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

protocol NoteEditViewControllerDelegate: class {
    
    func noteEditViewController(_ controller: NoteEditViewController, didFinishAdding note: Note)
    
}

class NoteEditViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var noteToEdit: Note?
    weak var delegate: NoteEditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = noteToEdit {
            noteTextView.isEditable = false
            noteTextView.text = note.text
            saveBarButton.title = ""
            saveBarButton.isEnabled = false
        } else {
            noteTextView.becomeFirstResponder()
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let note = Note(text: noteTextView.text)
        delegate?.noteEditViewController(self, didFinishAdding: note)
        
    }
    
}
