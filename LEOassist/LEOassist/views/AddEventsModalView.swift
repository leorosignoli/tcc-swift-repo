import SwiftUI

struct IntegrationEventsModalView: View {
    @Binding var isModalPresented: Bool
    @ObservedObject var events: Events

    var body: some View {
        VStack {
            VStack {
                if events.items != nil {
                    List(events.items!, id: \.id) { event in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(event.title)
                                .font(.headline)
                            Text("Início: \(event.startDate)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Fim: \(event.startDate)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Divider()
                        }
                        .padding([.top, .bottom], 10)
                    }
                    .padding([.leading, .trailing], 10)
                    Spacer()
                    AddEventsButton (action: {
                        isModalPresented = false
                    }, events: events)
                    .padding([.leading, .trailing], 20)
                } else {
                    Spacer()

                    Text("Não foram encontrados eventos no calendário.")
                        .padding(.bottom, 350)
                        .padding([.leading, .trailing], 30)
                    
                    Button(action: {
                        self.isModalPresented = false
                    }) {
                        Text("Fechar")
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .onDisappear(){
            isModalPresented = false
        }
    }
}
