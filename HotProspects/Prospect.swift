//
//  Prospect.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 20/03/22.
//

import Foundation
import Combine

class Prospect: Identifiable, Codable {
    var id: UUID
    var name = "Anonymus"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    init() {
        self.id = UUID()
    }
}


@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
        
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
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
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
