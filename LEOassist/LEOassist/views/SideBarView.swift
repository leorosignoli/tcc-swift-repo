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
                
                    GreekLetterAnimatedText(text: "Agenda")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(Color("THEME_BLUE"))
                }
                .padding(.top, 110)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
                .padding([.top,.bottom])
            
            NavigationLink(destination: MyProfileView()) {
                HStack {
                    
                    GreekLetterAnimatedText(text: "Perfil")
                        .font(.title3)

                    Spacer()

                    Image(systemName: "person.fill")
                        .foregroundColor(Color("THEME_YELLOW"))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
                .padding([.top,.bottom])

            
            NavigationLink(destination: ChatView()) {
                HStack {
  
                    GreekLetterAnimatedText(text: "Manager")
                        .font(.title3)

                    Spacer()
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(Color("THEME_RED"))
                        .scaleEffect(x: -1, y: 1)

                    Image(systemName: "text.bubble")
                        .foregroundColor(Color("THEME_RED"))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
            
            Divider()
                .padding([.top,.bottom])

            
            Spacer()
            
            Divider()
            
            
            HStack{
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(Color("THEME_RED"))
                
                Button("# Fazer Logout") {
                    auth0Service.logout()
                    isAuthenticated = false
                }
                .foregroundColor(Color("THEME_RED"))
                NavigationLink(destination: LoginPageView(), isActive: .constant(!isAuthenticated)) {
                      EmptyView()
                }
                
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
