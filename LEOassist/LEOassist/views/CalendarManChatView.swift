
import SwiftUI


struct ChatView: View {
    
    @State private var text = ""
    @AppStorage("messages") private var messagesData: Data = Data()
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    @EnvironmentObject var userProfile : Profile
    
    
    
    init() {
        if let savedMessages = try? JSONDecoder().decode([ChatMessage].self, from: messagesData) {
            self._messages = State(initialValue: savedMessages)
        }
    }
    
    
    var body: some View {
        NavigationViewWithSidebar {
            
            Button("Nova conversa"){
                messages = []
                messagesData = try! JSONEncoder().encode(messages)
            }
            Divider()
                .padding(.top)
            
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            HStack {
                                if message.role == "user"{
                                    Spacer()
                                    Text(message.content!)
                                        .padding(.all, 12)
                                        .background(ChatBubble(isUser: true).fill(Color("THEME_BLUE")))
                                        .foregroundColor(.white)
                                    
                                } else if message.role == "assistant" {
                                    if let content = message.content, !content.isEmpty {
                                        Text(content)
                                            .foregroundColor(Color.white)
                                            .padding(.all, 12)
                                            .background(ChatBubble(isUser: false).fill(Color("THEME_YELLOW")))
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal)
                    
                    
                }
                .padding(.top, 40.0)
                
                
                
                Divider()
                
                HStack {
                    
                    TextField("Digite Uma mensagem...", text: $text)
                        .padding(.leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .buttonBorderShape(.roundedRectangle(radius: 15))
                        .shadow(radius: 2)
                    
                    Button(action: {
                        if (!text.isEmpty){
                            isLoading = true
                            
                            messages.append(ChatMessage(content: text, role: "user"))
                            messagesData = try! JSONEncoder().encode(messages)
                            ChatWorkflowService.chatWithBot(conversation: messages, owner: userProfile.email) { (newMessages) in
                                messages = newMessages
                                messagesData = try! JSONEncoder().encode(messages)
                                isLoading = false
                            }
                        }
                        text = ""
                    }) {
                        Text("Enviar")
                            .padding([.leading, .trailing], 25)
                            .foregroundColor(.white)
                            .frame(height: 30 * 1.25)
                            .background(Color("THEME_RED"))
                            .cornerRadius(8)
                            .disabled(isLoading)
                    }
                }.padding()
                    .background(Color("BACKGROUND-COLORS"))
                
            }
            .modifier(DismissKeyboardOnTap())

        }
    }
    
    func getMessages() -> [ChatMessage]{
        return messages
    }
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
