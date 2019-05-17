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
    func noteEditViewController(_ controller: NoteEditViewController, didFinishEditing note: Note, withChanges: Bool)
    
}

final class NoteEditViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    // MARK: Properties
    
    var noteToEdit: Note?
    var noteToPreview: Note?
    weak var delegate: NoteEditViewControllerDelegate?

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        
        if let note = noteToPreview {
            noteTextView.isEditable = false
            noteTextView.text = note.text
            saveBarButton.title = ""
            saveBarButton.isEnabled = false
        } else if let note = noteToEdit {
            noteTextView.text = note.text
            saveBarButton.title = "Редактировать"
            noteTextView.becomeFirstResponder()
        } else {
            noteTextView.becomeFirstResponder()
        }
        
    }
    
    // MARK: - Button actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if let note = noteToEdit {
            let wasChanged = note.text != noteTextView.text
            note.text = noteTextView.text
            delegate?.noteEditViewController(self, didFinishEditing: note, withChanges: wasChanged)
        } else {
            let note = Note(text: noteTextView.text)
            delegate?.noteEditViewController(self, didFinishAdding: note)
        }
        
    }
    
}
