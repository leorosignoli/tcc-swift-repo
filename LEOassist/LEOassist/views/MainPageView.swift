import SwiftUI
import EventKit
import SDWebImageSwiftUI

struct MainPageView: View {
    @State var selectedDate : Date?
    @State private var isModalPresented = false  // to control the presentation of the modal
    @StateObject private var events = Events()
    @EnvironmentObject var userProfile: Profile
    @State  var selectedtDateEvents: [Event] = []

    let eventStore = EKEventStore()
    let iosService = IOSService()
    let outlookService = OutlookService()
    let eventMapper = EventMapper()

 
    var body: some View {
        NavigationViewWithSidebar {
            VStack {
                GreekLetterAnimatedText(text: "Sincronizar com... ")
                HStack{
                    integratedPlatformsButtonWithSheet(text: "iOS", icon: Image(systemName: "calendar"), action: {
                        iosService.getiOSCalendarData { eventStore, events in
                            if let events = events {
                                self.events.items = eventMapper.mapListToEvent(items: events)
                                self.presentModal()
                            }
                        }
                    })
                    
                    integratedPlatformsButtonWithSheet(text: "Outlook", icon: Image("OUTLOOK_CALENDAR_ICON"), action: {
                        MSALAuthentication.signin(completion: { securityToken, isTokenCached, expiresOn in
                            guard let token = securityToken else {
                                print("failed to get the security token.")
                                return
                            }

                            outlookService.fetchEvents(withToken: token) { (events, error) in
                                guard let events = events, error == nil else {
                                    print("Failed to fetch events")
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    self.events.items = events
                                }

                            }
                        })
                        self.presentModal()

                    })


                    integratedPlatformsButtonWithSheet(text: "Google", icon: Image("GOOGLE_CALENDAR_ICON"), action: {
                        isModalPresented = true
                    })
                }
                Divider()
                    .frame(height: 1)
                CalendarView(selectedDate : $selectedDate, selectedDateEvents: $selectedtDateEvents)

               
                    if !selectedtDateEvents.isEmpty{
                        List(selectedtDateEvents, id: \.id) { event in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(event.title)
                                    .font(.headline)
                                Text("Início: \(event.startDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Fim: \(event.startDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding([.top, .bottom], 5)
                            
                        }
                        .foregroundColor(.primary)
                        .frame(height: 250)

                        
                    } else {
                        Text("Sem eventos na data selecionada.")
                            .foregroundColor(.secondary)
                                .frame(height: 200)
                                .background(Color(.systemBackground))
                                .border(Color.secondary, width: 300)
                            
                    }
                
                
                
                
                AddNewEventButton()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
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
            IntegrationEventsModalView(isModalPresented: $isModalPresented, events: events)
        }
    }
}

class Events: ObservableObject {
    @Published var items: [Event]?
}


//Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        let mockEvents: [Event] = [
            Event(id: "1", title: "Apresentação do TCC (evento 1)", startDate: "2023-09-15", endDate: "2023-09-16"),
            Event(id: "2", title: "Event 2", startDate: "2023-09-17", endDate: "2023-09-18"),
            Event(id: "3", title: "Event 3", startDate: "2023-09-19", endDate: "2023-09-20")
        ]

        MainPageView(selectedtDateEvents: mockEvents)
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
