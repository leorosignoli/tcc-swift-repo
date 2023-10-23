import SwiftUI
import Auth0
import AVKit


struct LoginPageView: View {
    
    @State private var isAuthenticated: Bool = false
    @EnvironmentObject var userProfile : Profile
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {

            VStack(alignment: .center) {

                GreekLetterAnimatedText(text: "Where your Calendar Meets Intelligence.")
                    .padding(.top, 400)
                    
                
                    .font(.headline)
                
              
                Spacer()

                
                Button(action: {
                    login()
                }) {
                    GreekLetterAnimatedText(text: "Fazer Log-in".uppercased())
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 70)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                        .background(Color("theme_white"))
                        .cornerRadius(30)
                        .padding(.top, 30)
                
                }
                .padding([.leading, .trailing], 40)
                .frame(height: 300)
                .padding(.bottom, 70)
                .padding(.top, 20)
                .cornerRadius(10)
                .shadow( color: .black, radius: 30)
                
                NavigationLink("", destination: MainPageView(),
                               isActive: $isAuthenticated)
                    .hidden()
                    .navigationBarItems(leading: EmptyView())
                    .navigationBarBackButtonHidden(true)
                    
                
                    
                 
                    
            }
            .padding([.leading, .trailing], 20)
            .background(
                Image(colorScheme == .dark ? "DARK_LOGIN" : "NORMAL_LOGIN")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .onTapGesture {
                checkIfAuthenticated()
            }

          
        
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    
    }
    
    func checkIfAuthenticated() {
        if let _ = UserDefaults.standard.string(forKey: "idToken") {
            print("User Already authenticated.")
            self.isAuthenticated = true
        }
        else {
            print("User is not authenticated yet.")
            self.isAuthenticated = false }
    }
    
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
                    UserDefaults.standard.set(credentials.idToken, forKey: "idToken")
                    
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
