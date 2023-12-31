
import SwiftUI
import EventKit

struct IntegratedPlatformsButton: View {
    var text: String
    var icon: Image
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack{
                GreekLetterAnimatedText(text: text)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 14, weight: .bold))
                    


                icon
                    .resizable() // Make the icon resizable
                    .aspectRatio(contentMode: .fit) // Keep the aspect ratio while fitting the size
                    .frame(height: 30) // Set the height to be the same as the button
                    .padding(.trailing, 20)
            }
            .frame(height: 50)
        }
        
        .padding([.leading, .trailing], 5)
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
}

struct AddNewEventButton: View{
    private var text = "Adicionar Novo Evento"
    var body: some View {
            
            HStack{
                
                NavigationLink(destination: NewEventView()) {
                    Image(systemName: "calendar.badge.plus")
                        .resizable() // Make the icon resizable
                        .aspectRatio(contentMode: .fit) // Keep the aspect ratio while fitting the size
                        .frame(height: 30) // Set the height to be the same as the button
                        .padding(.trailing, 10)
                        .foregroundColor(Color("THEME_YELLOW"))
                    Text(text)
                    
                }

            }
        
        
    }
}

struct AddEventsButton: View{
    var text: String = "Sincronizar eventos"
    var action: () -> Void
    @ObservedObject var events: Events
    @EnvironmentObject var userProfile : Profile

    var body: some View {
        Button(action: {
            EventsService.syncEvents(userProfile: userProfile, events: events) {
                action()
            }
        }) {
            HStack {
                Text(text)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.leading, 50)
                Spacer()
                    
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .padding(.trailing, 30)
            }
            .frame(height: 50)
            .background(Color.green)
            .cornerRadius(30)
        }
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 20)
        .padding(.top, 20)
        .cornerRadius(10)
        .shadow(radius: 15)
    }
}

struct ButtonsPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            IntegratedPlatformsButton(text: "example", icon: Image("GOOGLE_CALENDAR_ICON"), action:  {})
            AddEventsButton(action:  {}, events: Events() )
            AddNewEventButton()

        }
        
    }
}
