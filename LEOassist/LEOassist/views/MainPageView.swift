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

    var body: some View {
        NavigationViewWithSidebar {
            VStack {
                GreekLetterAnimatedText(text: "Sincronizar com... ")
                HStack{
                    integratedPlatformsButtonWithSheet(text: "iOS", icon: Image(systemName: "calendar"), action: {
                        iosService.getiOSCalendarData { eventStore, events in
                            if let events = events {
                                self.events.items = events
                                self.presentModal()
                            }
                        }
                    })
                    integratedPlatformsButtonWithSheet(text: "Outlook", icon: Image("OUTLOOK_CALENDAR_ICON"), action: {
                        isModalPresented = true
                    })
                    integratedPlatformsButtonWithSheet(text: "Google", icon: Image("GOOGLE_CALENDAR_ICON"), action: {
                        isModalPresented = true
                    })
                }
                Divider()
                    .frame(height: 1)
                CalendarView(selectedDate : $selectedDate, selectedDateEvents: $selectedtDateEvents)
                    .scaledToFit()
                
               
                    if !selectedtDateEvents.isEmpty{
                        List(selectedtDateEvents, id: \.id) { event in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(event.title)
                                    .font(.headline)
                                Text("Início: \(event.startDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Fim: \(event.startDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Divider()
                            }
                            .padding([.top, .bottom], 10)
                            
                        }
                        .padding([.leading, .trailing], 15)
                        .foregroundColor(.primary)

                        .cornerRadius( 20)
                        
                    } else {
                        Text("Sem eventos na data selecionada.")
                            
                    }
                
                
                
                
                AddNewEventButton()
                    .padding(.top, 50)
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
    @Published var items: [EKEvent]?
}


//Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        let mockEvents: [Event] = [
            Event(id: "1", title: "Event 1", startDate: "2023-09-15", endDate: "2023-09-16"),
            Event(id: "2", title: "Event 2", startDate: "2023-09-17", endDate: "2023-09-18"),
            Event(id: "3", title: "Event 3", startDate: "2023-09-19", endDate: "2023-09-20")
        ]

        MainPageView(selectedtDateEvents: mockEvents)
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
