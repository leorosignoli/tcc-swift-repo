
import SwiftUI

struct IntegratedPlatformsButton: View {
    var text: String
    var icon: Image
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack{
                GreekLetterAnimatedText(text: text)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .bold))

                icon
                    .resizable() // Make the icon resizable
                    .aspectRatio(contentMode: .fit) // Keep the aspect ratio while fitting the size
                    .frame(height: 30) // Set the height to be the same as the button
                    .padding(.trailing, 20)
            }
            .frame(height: 50)
        }
        .overlay(
                   RoundedRectangle(cornerRadius: 15)
                       .stroke(Color.black, lineWidth: 2)
               )
        .padding([.leading, .trailing], 5)
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
}

struct AddNewEventButton: View{
    private var text = "Adicionar Novo Evento"
    var body: some View {
        HStack{
            Image(systemName: "calendar.badge.plus")
                .resizable() // Make the icon resizable
                .aspectRatio(contentMode: .fit) // Keep the aspect ratio while fitting the size
                .frame(height: 30) // Set the height to be the same as the button
                .padding(.trailing, 10)
            Button(text) {
             NewEventView()
            }
        }
        
    }
}

struct AddEventsButton: View{
    var text: String = "Sincronizar eventos"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
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
            AddNewEventButton()
            IntegratedPlatformsButton(text: "example", icon: Image("GOOGLE_CALENDAR_ICON"), action:  {})
            AddEventsButton(action:  {})
        }
        
    }
}
