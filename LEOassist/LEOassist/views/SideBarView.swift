import SwiftUI
import Auth0

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
                                Image(systemName: "line.horizontal.3.circle.fill")
                                    .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 30 * 1.1, height: 30 * 1.1)
                                       .padding(.leading, 10)
                                       .foregroundColor(Color("THEME_BLUE"))
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
    private let auth0Service = Auth0Service()
    @State private var isAuthenticated: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: MainPageView()) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("THEME_BLUE"))
                        
                    GreekLetterAnimatedText(text: "Agenda")
                }
                .padding(.top, 110)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
            
            NavigationLink(destination: MyProfileView()) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("THEME_YELLOW"))

                    GreekLetterAnimatedText(text: "Meu Perfil")
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
            NavigationLink(destination: ChatView()) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(Color("THEME_RED"))

                    GreekLetterAnimatedText(text: "Calendar Man")
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            Spacer()
            Divider()
            
            Button("# Logout") {
                auth0Service.logout()
                isAuthenticated = false
            }
            
            NavigationLink(destination: LoginPageView(), isActive: .constant(!isAuthenticated)) {
                  EmptyView()
            }
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
