//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 20/03/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
    case none, uncontacted, contacted
}

struct ProspectsView: View {
    @State private var isShowingScanner = false
    @EnvironmentObject var prospects: Prospects
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
                ForEach(Array(filteredProspects.enumerated()), id: \.offset) { index, prospect in
                    VStack(alignment: .leading) {
                        HStack {
                            if filter == .none {
                                Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark"
                                                                       : "person.crop.circle.badge.xmark")
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
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Fabio Tiberio\nfabiotibe.bit@gmail.com", completion: handleScan)
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
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.sound, .alert, .badge]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
