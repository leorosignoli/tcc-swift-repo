
import SwiftUI
import EventKit


struct MainPageView: View {
    @State var selectedDate: Date = Date()
    @State private var isModalPresented = false  // to control the presentation of the modal
    @State private var events: [EKEvent]?




    var body: some View {
        NavigationViewWithSidebar {
            
            VStack {
                
                GreekLetterAnimatedText(text: "Sincronizar com... ")
                    .padding(.bottom , 10)
                    .padding(.top, 10)
                
                HStack{
                     
                    IntegratedPlatformsButton(text:"iOS"){
                        isModalPresented = true
                        getiOSCalendarData()
                    }
                    .sheet(isPresented: $isModalPresented) {
                        
                        VStack{
                            if let unwrappedEvents = events {
                                    VStack {
                                        ForEach(unwrappedEvents, id: \.eventIdentifier) { event in
                                            Group {
                                                Text("Title: \(event.title ?? "")")
                                                Text("Start Date: \(event.startDate.description)")
                                                Text("End Date: \(event.endDate.description)")
                                                Text("~-~-~-~-~-~-~-~")
                                            }
                                        }
                                        Spacer()
                                        AddEventsButton(){
                                            
                                        }
                                    }
                                } else {
                                    Text("Não foram encontrados eventos no seu calendário.")
                                }

                        }
                        .onDisappear(){
                            isModalPresented = false
                        }
                    }
                    
                    IntegratedPlatformsButton(text:"Outlook") {
                        
                    }
                    IntegratedPlatformsButton(text:"Google") {
                        
                    }
                    
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
                
                Spacer().frame(height: 300)
            }
        
            .padding(.vertical, 100)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}

extension MainPageView {


    func getiOSCalendarData() {
            let eventStore = EKEventStore()
            
            switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                getCalendarEvents(eventStore: eventStore)
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion: { (granted, error) in
                    if granted {
                        DispatchQueue.main.async {
                            self.getCalendarEvents(eventStore: eventStore)
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
            self.events = events
        }
    
}
 

//Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
