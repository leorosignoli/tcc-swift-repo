
import SwiftUI
import EventKit


struct MainPageView: View {
    @State var selectedDate: Date = Date()


    var body: some View {
        NavigationViewWithSidebar {
            
            VStack {
                
                GreekLetterAnimatedText(text: "Sincronizar com... ")
                    .padding(.bottom , 10)
                    .padding(.top, 10)
                
                HStack{
                     
                    IntegratedPlatformsButton(text:"iOS"){
                        getiOSCalendarData()
                    }
                      
                    
                    IntegratedPlatformsButton(text:"Outlook") {
                        
                    }
                    IntegratedPlatformsButton(text:"Google") {
                        
                    }
                    
                }
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 28))
                    .bold()
                    .foregroundColor(Color.accentColor)
                    .padding()
                    .animation(.spring(), value: selectedDate)
                    .frame(width: 500)
                
                Divider().frame(height: 1)
                
                DatePicker("Selecione uma data", selection: $selectedDate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                
                Spacer().frame(height: 300)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            .padding(.vertical, 100)
        }
    }
}

extension MainPageView {
    
    struct Event: Encodable {
        let title: String
        let startDate: Date
        let endDate: Date
    }

    func getiOSCalendarData()  {
        var events: [Event] = []

        let store = EKEventStore()

        let calendars = store.calendars(for: .event)

        for calendar in calendars {
            if calendar.title == "Work" {
                let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = Date(timeIntervalSinceNow: 30*24*3600)
                let predicate = store.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
                let calendarEvents = store.events(matching: predicate)

                for event in calendarEvents {
                    let eventObj = Event(
                        title: event.title,
                        startDate: event.startDate,
                        endDate: event.endDate
                    )
                    events.append(eventObj)
                }
            }
        }

        let dataObj = ["data": events]

        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(dataObj) else {
            print("Failed to turn events to json")
            return
        }
        print(jsonData)
        
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}


struct IntegratedPlatformsButton: View{
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GreekLetterAnimatedText(text: text)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .background(.black)
                .cornerRadius(30)
        }
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 20)
        .padding(.top, 20)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
