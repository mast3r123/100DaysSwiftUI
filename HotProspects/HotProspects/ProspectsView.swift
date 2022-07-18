//
//  ProspectsView.swift
//  HotProspects
//
//  Created by master on 7/13/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { propspect in
                    VStack(alignment: .leading) {
                        Text(propspect.name)
                            .font(.headline)
                        Text(propspect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if propspect.isContacted {
                            Button {
                                prospects.toggle(propspect)
                            } label: {
                                Label("", systemImage: "person.crop.circle.fill.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(propspect)
                            } label: {
                                Label("", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(prospect: propspect)
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
                CodeScannerView(codeTypes: [.qr], simulatedData: "Master\nsample@gmail.com", completion: handleScan)
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted }
        case .uncontacted:
            return prospects.people.filter{ !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let prospect = Prospect()
            prospect.name = details[0]
            prospect.emailAddress = details[1]
            prospects.add(prospect: prospect)
            
        case .failure(let error):
            print(error.localizedDescription)
            
        }
    }
    
    func addNotification(prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = "Contact \(prospect.emailAddress)"
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request )
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.sound, .alert, .badge]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        //
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
