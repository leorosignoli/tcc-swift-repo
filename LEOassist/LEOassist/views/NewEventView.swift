import SwiftUI

struct NewEventView: View {
    @State private var eventName = ""
    @State private var eventStartDateTime = Date()
    @State private var eventEndDateTime = Date()
    @EnvironmentObject private var userData : Profile
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var isFormValid: Bool {
        !eventName.isEmpty && eventEndDateTime >= eventStartDateTime
    }
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                
                Form {
                    
                    Section(header: Text("Detalhes do evento").padding().background(.white).cornerRadius(15)) {
                        TextField("Título", text: $eventName)
                            .font(.title2)
                            .padding()
                            .background(Color("BACKGROUND-COLORS"))
                            .cornerRadius(20)
                        DatePicker("Início", selection: $eventStartDateTime, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding( .bottom)
                        DatePicker("Fim", selection: $eventEndDateTime, in: eventStartDateTime..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding([.top, .bottom])
                    }
                    .scrollContentBackground(.hidden) // 👈 this line will work only on iOS 16 and above
                    .background(.white)
                    .padding(.all)
                    .cornerRadius(20)
                    
                    
                    
                }
                .scrollContentBackground(.hidden) // 👈 this line will work only on iOS 16 and above
                .background(Color("BACKGROUND-COLORS"))
                .cornerRadius(20)
                
                .padding(.horizontal)
                .padding([.top, .bottom], 100)
                .cornerRadius(100)
                
                
                Button(action: {
                    print("Create Event button tapped")
                    EventsService.addSingleEvent(
                        userProfile: userData,
                        event: EventData(title: eventName,
                                         startDate: backEndApiDateFormatter.string(from: eventStartDateTime),
                                         endDate: backEndApiDateFormatter.string(from: eventEndDateTime),
                                         integrationId: "USER-CREATED")) { result in
                                             DispatchQueue.main.async {
                                                 switch result {
                                                 case .success:
                                                     alertMessage = "Evento Criado!"
                                                 case .failure:
                                                     alertMessage = "Houve uma falha ao criar o evento. Por favor, tente novamente."
                                                 }
                                                 showAlert = true
                                             }
                                         }
                })
                {
                    Text("Criar evento")
                        .font(.title3)
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("THEME_BLUE"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMessage))
                    
                }
                
            }
            .navigationBarTitle("Novo evento", displayMode: .inline)
            .cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
            
        }
        
    }
}

struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
