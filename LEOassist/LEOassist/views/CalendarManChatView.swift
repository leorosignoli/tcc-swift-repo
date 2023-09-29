
import SwiftUI

struct Message: Identifiable, Codable {
    var id = UUID()
    var text: String
    var isUser: Bool
}
struct ChatView: View {

    @State private var text = ""
    @AppStorage("messages") private var messagesData: Data = Data()
    @State private var messages: [Message] = []

    init() {
        if let savedMessages = try? JSONDecoder().decode([Message].self, from: messagesData) {
            self._messages = State(initialValue: savedMessages)
        }
    }


    var body: some View {
           NavigationViewWithSidebar {
               Divider()
                   .padding(.top)
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
                   
                
                   Divider()

                HStack {
                    Image(systemName: "plus.message.fill")
                        .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 20 * 1.25)
                           .padding(.leading, 10)
                           .foregroundColor(Color("THEME_YELLOW"))

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
                            messagesData = try! JSONEncoder().encode(messages)
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
