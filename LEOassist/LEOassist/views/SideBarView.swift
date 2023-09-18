import SwiftUI

struct NavigationViewWithSidebar<Content: View>: View {
    @State private var showMenu = false // to control showing and hiding of the menu

    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
         self.content = content()
     }
        
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    self.content
                        .navigationBarItems(leading:
                            Button(action: {
                                withAnimation {
                                    self.showMenu.toggle()
                                }
                            }){
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                            }
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showMenu ? true : false)
                    
                    if self.showMenu {
                        MenuView()
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
            }

            .gesture(drag)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}

struct MenuView: View {
    
    @State private var showLoginPage = true
    

    
    var body: some View {
        VStack(alignment: .leading) {

            NavigationLink(destination: MainPageView()) {
                GreekLetterAnimatedText(text: "Agenda")
                    .padding(.top, 110)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
            
            NavigationLink(destination: MyProfileView()) {
                GreekLetterAnimatedText(text: "Meu Perfil")
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            Divider()
            
            Spacer()
            Divider()
            
            
            Button("# Logout") {
                self.showLoginPage = true
            }
            .foregroundColor(Color.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .edgesIgnoringSafeArea(.top)
        .SideBarBackground()
    }
    
}

struct SidebarView_preview: PreviewProvider {
    static var previews: some View {
        NavigationViewWithSidebar {
        }
        .environmentObject(Profile.from(Constants.MOCK_TOKEN))
    }
}
