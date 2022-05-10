//
//  AddNotificationView.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 10/05/22.
//
import UserNotifications
import SwiftUI

public enum NotificationError: LocalizedError {
    case missingPermissions
    
    public var errorDescription: String? {
        "Error"
    }
    public var failureReason: String? {
        "Notification aren't enabled for HotProspects"
    }
    
    public var recoverySuggestion: String? {
        "Go to Settings>>HotProspects>>Notifications to activate notifications for this app"
    }
}

struct AddNotificationView: View {
    public var prospect: Prospect
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date = Date.now
    @State private var isShowingConfirmationDialog = false
    @State private var error: NotificationError?
    
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
        .alert(isPresented: $isShowingConfirmationDialog, error: error) { error in
            Button("Dismiss") {
                dismiss()
            }
        } message: { error in
            
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
                        self.error = NotificationError.missingPermissions
                        DispatchQueue.main.async {
                            self.isShowingConfirmationDialog = true
                        }
                    }
                }
            }
        }
    }
    
}

struct AddNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationView(prospect: Prospect())
    }
}
