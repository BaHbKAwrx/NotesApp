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
    
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var shareBarButton: UIBarButtonItem!
    
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
            shareBarButton.isEnabled = true
            shareBarButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
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
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let note = noteToPreview else { return }
        let itemsToShare = [note.text]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    
}
