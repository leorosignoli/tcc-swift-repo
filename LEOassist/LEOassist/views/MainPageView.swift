
import SwiftUI
import EventKit


struct MainPageView: View {
    @State var selectedDate: Date = Date()
    @State private var isModalPresented = false  // to control the presentation of the modal
    @StateObject private var events = Events()
    let eventStore = EKEventStore() 





    var body: some View {
        NavigationViewWithSidebar {
            
            VStack {
                
                GreekLetterAnimatedText(text: "Sincronizar com... ")
                    .padding(.bottom , 10)
                    .padding(.top, 10)
                
                HStack{
                     
                    integratedPlatformsButtonWithSheet(text: "iOS", icon: Image(systemName: "calendar"), action: {
                                    getiOSCalendarData()
                                })
                    
                    integratedPlatformsButtonWithSheet(text: "Outlook", icon: Image("OUTLOOK_CALENDAR_ICON"), action: {
                        isModalPresented = true
                        
                    })
                    integratedPlatformsButtonWithSheet(text: "Google", icon: Image("GOOGLE_CALENDAR_ICON"), action: {
                        isModalPresented = true
                        
                    })
                    
                }
                GreekLetterAnimatedText(text: selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 28))
                    .bold()
                    .foregroundColor(Color.accentColor)
                    .padding()
                    .animation(.spring(), value: selectedDate)
                    .frame(width: 500)
                
                Divider()
                    .frame(height: 1)
                
                DatePicker("Selecione uma data", selection: $selectedDate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                    
                
                AddNewEventButton()
                .padding(.top, 200)
                
                
            }
        
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}

extension MainPageView {


    func getiOSCalendarData() {
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            getCalendarEvents(eventStore: eventStore)
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        let newEventStore = EKEventStore() // New instance after access granted
                        self.getCalendarEvents(eventStore: newEventStore)
                    }
                }
            })
        default:
            print("Access denied")
        }
    }

    func getCalendarEvents(eventStore: EKEventStore) {
        let startDate = Date().addingTimeInterval(-60*60*24) // 1 day before now
        let endDate = Date().addingTimeInterval(60*60*24*30) // 30 days after now
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)

        self.events.items = events

        self.events.items?.forEach { event in
                print("Found event: \(event.title ?? "N/A")")
            }
        
        
        DispatchQueue.main.async {
            self.events.items = nil // Clear events items before reassigning
            self.events.items = events
            print("Found \(self.events.items?.count ?? 0) events")
            self.presentModal()
            
        }
    }

    func presentModal() {
        self.isModalPresented = true
    }
    

    
    func integratedPlatformsButtonWithSheet(text: String, icon: Image, action: @escaping () -> Void) -> some View {
        IntegratedPlatformsButton(text: text, icon: icon) {
            DispatchQueue.main.async {
                events.items = nil // Clear events.items before fetching new events

                action()
            }
        }
        .sheet(isPresented: $isModalPresented) {
            sheetContent()
        }
    }
    
    func sheetContent() -> some View {
        VStack{
            VStack {
               
                if events.items != nil {
                    List(events.items!, id: \.eventIdentifier) { event in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(event.title ?? "")
                                .font(.headline)
                            Text("Início: \(dateFormatter.string(from: event.startDate))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Fim: \(dateFormatter.string(from: event.startDate))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Divider()
                        }
                        .padding([.top, .bottom], 10)
                    }
                    .padding([.leading, .trailing], 10)
                    Spacer()
                    AddEventsButton {
                        // TODO: Integrate with api
                        isModalPresented = false
                    }
                    .padding([.leading, .trailing], 20)
                } else {
                    Spacer()

                    Text("Não foram encontrados eventos no calendário.")
                        .padding(.bottom, 350)
                        .padding([.leading, .trailing], 30)
                    
                    Button(action: {
                        self.isModalPresented = false
                    }) {
                        Text("Fechar")
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .onDisappear(){
            isModalPresented = false
        }
    }


}
 
class Events: ObservableObject {
    @Published var items: [EKEvent]?
}

//Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
