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
    
    var searchController = UISearchController(searchResultsController: nil)
    private var dataModel = DataModel()

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddNote" {
            
            if let controller = segue.destination as? NoteEditViewController {
                controller.delegate = self
            }
            
        } else if segue.identifier == "NoteDetail" {
            
            if let controller = segue.destination as? NoteEditViewController {
                
                if let cell = sender as? NoteTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    controller.noteToPreview = noteToDisplayAt(indexPath: indexPath)
                }
                
            }
            
        } else if segue.identifier == "EditNote" {
            
            if let controller = segue.destination as? NoteEditViewController {
                controller.noteToEdit = sender as? Note
                controller.delegate = self
            }
            
        }
        
    }
    
    // MARK: - Method for setup searchController
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation - same as bottom one
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        // To hide searchBar on next VC
        definesPresentationContext = true
        
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
        
        tableView.reloadData()
//        if let index = dataModel.notes.firstIndex(where: {$0 === note}) {
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
        
        dataModel.saveNotes()
        
        navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source and delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return dataModel.filteredNotes.count
        } else {
            return dataModel.notes.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? NoteTableViewCell {
            let note = noteToDisplayAt(indexPath: indexPath)
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
            let note = self?.noteToDisplayAt(indexPath: indexPath)
            self?.performSegue(withIdentifier: "EditNote", sender: note)
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (rowAction, indexPath) in
            if (self?.searchController.isActive)! && self?.searchController.searchBar.text != "" {
                if let deletedItem = self?.dataModel.filteredNotes.remove(at: indexPath.row) {
                    if let index = self?.dataModel.notes.index(of: deletedItem) {
                        self?.dataModel.notes.remove(at: index)
                    }
                }
            } else {
                self?.dataModel.notes.remove(at: indexPath.row)
            }
            //self?.dataModel.notes.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            self?.dataModel.saveNotes()
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        return [deleteAction,editAction]
        
    }
    
    // MARK: - Button actions
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let descendingAlertAction = UIAlertAction(title: "От новых к старым", style: .default) {[weak self] (action) in
            self?.dataModel.sortNotes(with: .descending)
            self?.tableView.reloadData()
        }
        let ascendingAlertAction = UIAlertAction(title: "От старых к новым", style: .default) {[weak self] (action) in
            self?.dataModel.sortNotes(with: .ascending)
            self?.tableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(descendingAlertAction)
        alertController.addAction(ascendingAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods for filtering
    
    func filterContentFor(searchText text: String) {
        
        dataModel.filteredNotes = dataModel.notes.filter { (note) -> Bool in
            return note.text.lowercased().contains(text.lowercased())
        }
        
    }
    
    func noteToDisplayAt(indexPath: IndexPath) -> Note {
        
        let note: Note
        if searchController.isActive && searchController.searchBar.text != "" {
            note = dataModel.filteredNotes[indexPath.row]
        } else {
            note = dataModel.notes[indexPath.row]
        }
        return note
        
    }
    
}

// Extension for searchController
extension AllNotesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentFor(searchText: text)
        tableView.reloadData()
    }
    
}

// Extension for limiting String lenght
extension String {
    
    func limitLenght(to lenght: Int, trailing: String = "...") -> String {
        
        return (self.count > lenght) ? self.prefix(lenght) + trailing : self
        
    }
    
}
