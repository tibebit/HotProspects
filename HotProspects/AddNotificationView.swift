//
//  AddNotificationView.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 10/05/22.
//
import UserNotifications
import SwiftUI

fileprivate struct NotificationError: LocalizedError {
    var errorDescription: String? {
        "Missing Permissions"
    }
    
    var failureReason: String? {
        "You haven't enabled HotProspects to send notifications to you"
    }
    
    var recoverySuggestion: String? {
        "Go to Settings"
    }
}

struct AddNotificationView: View {
    public var prospect: Prospect
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date = Date.now
    @State private var isPresentingAlert = false
    @State private var notificationError: NotificationError?
    
    var body: some View {
        Form {
            Section("Set Notification Time") {
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            .font(.title)
            Button {
                addNotification(on: date)
            } label: {
                Text("Set Notification")
                    .frame(maxWidth: .infinity)
            }
            
        }
        .alert(isPresented: $isPresentingAlert, error: notificationError) { error in
            Button(error.recoverySuggestion!, action: {
                openSettings()
            })
        } message: { error in
            Text(error.failureReason!)
        }
    }
    
    private func addNotification(on date: Date) {
        
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = Calendar.current.component(.hour, from: date)
            dateComponents.minute = Calendar.current.component(.minute, from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
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
                        notificationError = NotificationError()
                        isPresentingAlert = true
                    }
                }
            }
        }
    }
    
    private func openSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url)
    }
}

struct AddNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationView(prospect: Prospect())
    }
}
