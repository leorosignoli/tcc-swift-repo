import SwiftUI
import EventKit
import SDWebImageSwiftUI

struct MainPageView: View {
    @State var selectedDate: Date = Date()
    @State private var isModalPresented = false  // to control the presentation of the modal
    @StateObject private var events = Events()
    @EnvironmentObject var userProfile: Profile
    @State private var apiEvents: [Event] = []

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
                UICalendarViewRepresentable(selectedDate: $selectedDate, events: $apiEvents)
                    .padding(.horizontal)
                    .onAppear {
                                    EventsService.fetchEvents(owner: userProfile.email) { events in
                                        self.apiEvents = events
                                    }
                    }
                AddNewEventButton()
                    .padding(.top, 140)
            }
            .DefaultBackground()
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

struct UICalendarViewRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var events: [Event]
    @EnvironmentObject var userProfile: Profile

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = context.coordinator
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .systemBackground
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Update the view if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate {
        var parent: UICalendarViewRepresentable

        init(_ parent: UICalendarViewRepresentable) {
            self.parent = parent
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            // Check if there is an event for the date and return a decoration if there is
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            for event in parent.events {
                if let startDate = dateFormatter.date(from: event.startDate),
                   let endDate = dateFormatter.date(from: event.endDate),
                   let date = calendarView.calendar.date(from: dateComponents),
                   startDate <= date && date <= endDate {
                    return UICalendarView.Decoration.default(color: .systemGreen, size: .large)
                }
            }
            return nil
        }
    }
}

//Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
