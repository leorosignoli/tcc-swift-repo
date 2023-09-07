
import SwiftUI

struct MainPage: View {
    @State var selectedDate: Date = Date()

        
    var body: some View {
        NavigationViewWithSidebar {
            VStack {
                
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 28))
                    .bold()
                    .foregroundColor(Color.accentColor)
                    .padding()
                    .animation(.spring(), value: selectedDate)
                    .frame(width: 500)
                    
                Divider().frame(height: 1)
                
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
             
                
                Spacer()
                    .frame(height: 300)// defines flexible space that expands along the major axis of its containing stack layout
            }
            .padding(.vertical, 100)
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
