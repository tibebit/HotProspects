//
//  Prospect.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 20/03/22.
//

import Foundation
import Combine

class Prospect: Identifiable, Codable, Comparable {
    var id: UUID
    var name = "Anonymus"
    var emailAddress = ""
    /// The date when the prospect has been created
    var date: Date
    
    fileprivate(set) var isContacted = false
    
    init() {
        self.id = UUID()
        self.date = Date()
    }
    
    static func ==(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.id == lhs.id
    }
    
    static func <(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name < rhs.name
    }
}


@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let fileName = "prospects.json"
        
    init() {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(fileName)) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func remove(at index: Int) {
        people.remove(at: index)
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: FileManager.documentsDirectory.appendingPathComponent(fileName), options: [.atomic, .completeFileProtection])
        }
    }
}
