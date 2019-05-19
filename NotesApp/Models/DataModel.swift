//
//  DataModel.swift
//  NotesApp
//
//  Created by Shmygovskii Ivan on 5/17/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation

struct DataModel {
    
    var notes = [Note]()
    
    init() {
        loadNotes()
        sortNotes(with: .descending)
    }
    
    // MARK: - Sorting methods
    
    mutating func sortNotes(with order: SortOrder) {
        
        switch order {
        case .ascending:
            notes.sort { (note1, note2) -> Bool in
                return note1.date.compare(note2.date) == .orderedAscending
            }
        case .descending:
            notes.sort { (note1, note2) -> Bool in
                return note1.date.compare(note2.date) == .orderedDescending
            }
        }
        
    }
    
    // MARK: - Data saving methods
    
    func saveNotes() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(notes)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error while encoding notes")
        }
        
    }
    
    private mutating func loadNotes() {
        
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                notes = try decoder.decode([Note].self, from: data)
            } catch {
                print("Error while decoding notes")
            }
        }
        
    }
    
    // Getting url for saving data
    private func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    private func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("NotesApp.plist")
        
    }
    
}
