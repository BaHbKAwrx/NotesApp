//
//  AllNotesViewController.swift
//  NotesApp
//
//  Created by Shmygovskii Ivan on 5/13/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

final class AllNotesViewController: UITableViewController, NoteEditViewControllerDelegate {
    
    // MARK: - Properties
    
    private var dataModel = DataModel()

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddNote" {
            
            if let controller = segue.destination as? NoteEditViewController {
                controller.delegate = self
            }
            
        } else if segue.identifier == "NoteDetail" {
            
            if let controller = segue.destination as? NoteEditViewController {
                
                if let cell = sender as? NoteTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    controller.noteToPreview = dataModel.notes[indexPath.row]
                }
                
            }
            
        } else if segue.identifier == "EditNote" {
            
            if let controller = segue.destination as? NoteEditViewController {
                controller.noteToEdit = sender as? Note
                controller.delegate = self
            }
            
        }
        
    }
    
    // MARK: - NoteEditVC delegates
    
    func noteEditViewController(_ controller: NoteEditViewController, didFinishAdding note: Note) {
        
        if !note.text.isEmpty {
            let newNoteIndex = 0
            dataModel.notes.insert(note, at: newNoteIndex)
            
            let indexPath = IndexPath(row: newNoteIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            
            dataModel.saveNotes()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func noteEditViewController(_ controller: NoteEditViewController, didFinishEditing note: Note, withChanges: Bool) {
        
        if withChanges {
            note.date = Date()
        }
        
        if let index = dataModel.notes.firstIndex(where: {$0 === note}) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        dataModel.saveNotes()
        
        navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source and delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? NoteTableViewCell {
            let note = dataModel.notes[indexPath.row]
            cell.configureWith(text: note.text.limitLenght(to: Constants.labelCharactersLimit), date: note.date)
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(Constants.cellHeight)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") {[weak self] (rowAction, indexPath) in
            let note = self?.dataModel.notes[indexPath.row]
            self?.performSegue(withIdentifier: "EditNote", sender: note)
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (rowAction, indexPath) in
            self?.dataModel.notes.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            self?.dataModel.saveNotes()
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        return [deleteAction,editAction]
        
    }

}

// Extension for limiting String lenght
extension String {
    
    func limitLenght(to lenght: Int, trailing: String = "...") -> String {
        
        return (self.count > lenght) ? self.prefix(lenght) + trailing : self
        
    }
    
}
