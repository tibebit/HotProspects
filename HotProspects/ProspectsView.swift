//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 20/03/22.
//

import SwiftUI
import CodeScanner

enum FilterType {
    case none, uncontacted, contacted
}

enum SortingType {
    case byDate, byName
}

struct ProspectsView: View {
    @State private var isShowingScanner = false
    @State private var sorting: SortingType = .byName
    @State private var isShowingSortingDialog = false
    @State private var isShowingNotificationDialog = false
    @EnvironmentObject var prospects: Prospects
    @State private var selectedProspect: Prospect?
    
    let filter: FilterType
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .uncontacted:
            return prospects.people.filter({!$0.isContacted})
        case .contacted:
            return prospects.people.filter({$0.isContacted})
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sorting {
        case .byName:
            return filteredProspects.sorted()
        case .byDate:
            return filteredProspects.sorted(by: { $0.date > $1.date })
        }
    }
    
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .uncontacted:
            return "Uncontancted People"
        case .contacted:
            return "Contacted People"
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(sortedProspects.enumerated()), id: \.offset) { index, prospect in
                    VStack(alignment: .leading) {
                        HStack {
                            if filter == .none {
                                Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark": "person.crop.circle.badge.xmark")
                                    .font(.title)
                                    .foregroundColor(prospect.isContacted ? .green : .blue)
                            }
                            Text(prospect.name)
                                .font(.headline)
                        }
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        
                        Button { prospects.remove(at: index) } label: {
                            Label("Remove", systemImage: "trash.circle")
                        }
                        .tint(.red)
                        
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            Button {
                                selectedProspect = prospect
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                    .confirmationDialog("Sort", isPresented: $isShowingSortingDialog, titleVisibility: .visible) {
                        Button("By Name") {
                            sorting = .byName
                        }
                        Button("By Most Recent") {
                            sorting = .byDate
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                    Button {
                        isShowingSortingDialog = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.square.fill")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Zaal Pepe\ngiorgiopepe@gmail.com", completion: handleScan)
            }
            .sheet(item: $selectedProspect) { prospect in
                AddNotificationView(prospect: prospect)
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count  == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
