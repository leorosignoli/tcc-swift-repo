import SwiftUI
import EventKit
import SDWebImageSwiftUI

struct MainPageView: View {
    @State var selectedDate : Date?
    @State private var isModalPresented = false  // to control the presentation of the modal
    @StateObject private var events = Events()
    @EnvironmentObject var userProfile: Profile
    @State  var selectedtDateEvents: [Event] = []
    @ObservedObject private var googleCalendar = GoogleCalendarManagerService()


    let eventStore = EKEventStore()
    let iosService = IOSService()
    let outlookService = OutlookService()
    let eventMapper = EventMapper()
    let dateFormatter = backEndApiDateFormatter

 
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
                                
                                let mappedEvents = updateEventsDates(events: events)
                                
                                DispatchQueue.main.async {
                                    self.events.items = mappedEvents
                                }

                            }
                        })
                        self.presentModal()

                    })


                    integratedPlatformsButtonWithSheet(text: "Google", icon: Image("GOOGLE_CALENDAR_ICON"), action: {
                        googleCalendar.fetchEvents()
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
                                Text("Início: \(formatTime(from:event.startDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Fim: \(formatTime(from:event.startDate))")
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


extension MainPageView {
    
    func updateEventsDates(events: [Event]) -> [Event] {
        return events.map { event in
            var newEvent = event
            newEvent.startDate = convertEventDate(eventDate: event.startDate)
            newEvent.endDate = convertEventDate(eventDate: event.endDate)
            return newEvent
        }
    }
    

    
     func convertEventDate(eventDate: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
            
            guard let dateObject = dateFormatter.date(from: eventDate) else {
                return "Error while converting the date"
            }

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let finalDateString = dateFormatter.string(from: dateObject)

            return finalDateString
        }
    
    func formatTime(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let dateObject = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: dateObject)
        
        return timeString
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
