

import SwiftUI

extension View {
    func DefaultBackground() -> some View {
        self.background(Color("BACKGROUND-COLORS").edgesIgnoringSafeArea(.all))
    }
}


extension View {
    func SideBarBackground() -> some View {
        self.background(Color("SIDEBAR-BACKGROUND-COLORS").edgesIgnoringSafeArea(.all))
    }
}







//preview
 
struct Background_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, World!")
            
                .padding(.all, 100)
                .DefaultBackground()
            Text("Hello, World!")
            
                .padding(.all, 100)
                .SideBarBackground()
        }
    }
}
