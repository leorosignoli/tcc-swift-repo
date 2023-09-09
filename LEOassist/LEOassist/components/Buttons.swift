
import SwiftUI

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

struct AddEventsButton: View{
    var text: String = "Adicionar eventos"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .background(Color.green)
            .cornerRadius(30)
        }
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 20)
        .padding(.top, 20)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

