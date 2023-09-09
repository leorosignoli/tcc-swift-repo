import SwiftUI
import Auth0


struct LoginPageView: View {
    
    @State private var isAuthenticated: Bool = false
    @EnvironmentObject var userProfile : Profile
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center) {
                
                
                Image("LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.bottom, 1)
                GreekLetterAnimatedText(text: "Where your Calendar Meets Intelligence")
                    .font(.headline)
                
              
                

                
                Button(action: {
                    login()
                }) {
                    GreekLetterAnimatedText(text: "Fazer Log-in".uppercased())
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                        .background(.black)
                        .cornerRadius(30)
                
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .cornerRadius(10)
                .shadow(radius: 40)
                
                NavigationLink("", destination: MainPageView(),
                               isActive: $isAuthenticated)
                    .hidden()
                    .navigationBarItems(leading: EmptyView())
                    .navigationBarBackButtonHidden(true)
                    
                Spacer()
                    .frame(height: 60)
                    
                 
                    
            }
            .padding([.leading, .trailing], 20)
            .background(
                Image("WHITE_GOLDEN_MARBLE")
                    .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                                        .rotationEffect(.degrees(90))
                                        .edgesIgnoringSafeArea(.all)
                                        .mask(LinearGradient(gradient: Gradient(stops: [
                                            .init(color: .black, location: 0.3),
                                                    .init(color: .clear, location: 1),
                                                    .init(color: .black, location: 1),
                                                    .init(color: .clear, location: 1)
                                                ]), startPoint: .bottom, endPoint: .top))
                                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.5)
                                        
                                    
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    
    }
        
    
}

extension LoginPageView {
    
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                    
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile.update(from : credentials.idToken)
                    
                    print("user: \(userProfile)")
                    print("Credentials: \(credentials)")
                    print("ID token: \(credentials.idToken)")
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}

