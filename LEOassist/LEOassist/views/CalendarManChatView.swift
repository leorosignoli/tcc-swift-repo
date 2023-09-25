
import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isUser: Bool
}
struct ChatView: View {

    @State private var text = ""
    @State private var messages: [Message] = [
        Message(text: "Hello!", isUser: true),
        Message(text: "How are you?", isUser: false),
        Message(text: "I'm doing great, thanks! I'm doing great, thanks! I'm doing great, thanks! I'm doing great, thanks! I'm doing great, thanks! I'm doing great, thanks! I'm doing great, thanks!", isUser: true),
        Message(text: "Glad to hear that!", isUser: false)
    ]

    var body: some View {
           NavigationViewWithSidebar {
               Divider()
                   .padding(.top)
                   .padding(.bottom, -8)
               VStack {
                   ScrollView {
                       VStack(spacing: 16) {
                           ForEach(messages) { message in
                               HStack {
                                   if message.isUser {
                                       Spacer()
                                       Text(message.text)
                                           .padding(.all, 12)
                                           .background(ChatBubble(isUser: true).fill(Color("THEME_BLUE")))
                                           .foregroundColor(.white)
                                   } else {
                                       Text(message.text)
                                           .foregroundColor(Color.white)
                                           .padding(.all, 12)
                                           .background(ChatBubble(isUser: false).fill(Color("THEME_YELLOW")))
                                       Spacer()
                                   }
                               }
                           }
                       }.padding(.horizontal)
                           
                       
                   }
                   .padding(.top, 40.0)
                   
                   .background(
                    Image("BACKGROUND_TEXTURE")
                        .resizable()
                        .scaledToFit())
                
                   Divider()
                       .padding(.top, -8)

                HStack {
                    TextField("Digite Uma mensagem...", text: $text)
                        .padding(.leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .buttonBorderShape(.roundedRectangle(radius: 15))
                    Image(systemName: "mic.square.fill")

                        .resizable()
                
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 30 * 1.25)
                           .padding(.leading, 10)
                           .foregroundColor(Color("THEME_BLUE"))
                    
                    Button(action: {
                        if (!text.isEmpty){
                            messages.append(Message(text: text, isUser: true))
                        }
                        text = ""
                    }) {
                        Text("Enviar")
                            .padding([.leading, .trailing], 25)
                            .foregroundColor(.white)
                            .frame(height: 30 * 1.25)
                            .background(Color("THEME_RED"))
                            .cornerRadius(8)
                        
                            
                    }
                }.padding()
            }
        }
    }
    
    func getMessages() -> [Message]{
        return messages
    }
}

struct ChatBubble: Shape {
    var isUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: isUser ? [.topLeft, .bottomLeft, .bottomRight] : [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
