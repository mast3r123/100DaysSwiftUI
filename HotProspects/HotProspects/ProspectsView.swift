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
    @State private var isShowingFilter = false
    
    let filter: FilterType
    
    @State private var selection = "By Names"
    var options = ["By Names", "Most Recent"]
    
    var body: some View {
        NavigationView {
            List {
                if isShowingFilter {
                    Section(header: Text("Sort Prospects")) {
                        Picker("Sort By", selection: $selection) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                Section(header: Text("Prospects")) {
                    ForEach(filteredProspects) { propspect in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(propspect.name)
                                    .font(.headline)
                                Text(propspect.emailAddress)
                                    .foregroundColor(.secondary)
                                
                            }
                            Spacer()
                            if filter == .none {
                                Image(systemName: propspect.isContacted ? "person.fill.checkmark" : "person.fill.questionmark")
                            }
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
            }
            .navigationTitle(title)
            .navigationBarItems(leading:
                                    Button {
                withAnimation {
                    isShowingFilter.toggle()
                }
            } label: {
                Label("Filter", systemImage: "arrow.up.arrow.down.square")
            }
            )
            .navigationBarItems(trailing:
                                    Button {
                isShowingScanner = true
            } label: {
                Label("Scan", systemImage: "qrcode.viewfinder")
            }
            )
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "\(generateRandomName())\n\(generateRandomName())@gmail.com", completion: handleScan)
            }
            .onChange(of: selection) { selection in
                prospects.sort(sortBy: selection)
            }
            
        }
    }
    
    func generateRandomName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
          return String((0..<6).map{ _ in letters.randomElement()! })
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
