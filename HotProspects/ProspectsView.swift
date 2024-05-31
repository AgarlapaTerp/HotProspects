//
//  ProspectsView.swift
//  HotProspects
//
//  Created by user256510 on 5/3/24.
//

import CodeScanner
import SwiftUI
import SwiftData
import UserNotifications

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    @State private var isShowingScanning = false
    
    @State private var selectedProspects = Set<Prospect>()
    
    
    
    
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted People"
        case .uncontacted:
            "Uncontacted People"
        }
    }
    
    var body: some View {
        
        List(prospects){prospect in
            NavigationLink(value: prospect) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if filter == .none {
                        Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.badge.xmark")
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage:
                                "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                                .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell"){
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
            
        }
        .navigationDestination(for: Prospect.self){ person in
            EditView(prospectToChange: person)
        }
        .navigationTitle(title)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing){
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    isShowingScanning = true
                }
            }
            
            
            ToolbarItem(placement: .topBarLeading){
                EditButton()
            }
            
            if selectedProspects.isEmpty == false {
                ToolbarItem(placement: .bottomBar){
                    Button("Delete Selected", action: delete)
                }
            }
        }
        .sheet(isPresented: $isShowingScanning){
            CodeScannerView(codeTypes: [.qr], simulatedData: "Abhi Garlapati\nmeetmesexy@abhigarlapati.com", completion: handleScan)
        }
        
    }
    
    
    init(filter: FilterType, sortDescriptors: [SortDescriptor<Prospect>]){
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: sortDescriptors)
        } else {
            _prospects = Query(sort:sortDescriptors)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>){
        isShowingScanning = false
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects = Set<Prospect>()
    }
    
    func addNotification(for prospect: Prospect){
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                
                center.requestAuthorization(options: [.alert,.badge,.sound]) { succ, error in
                    if succ {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ProspectsView(filter: .none, sortDescriptors: [])
        .modelContainer(for: Prospect.self)
}
