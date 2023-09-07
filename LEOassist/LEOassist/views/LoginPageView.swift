import SwiftUI
import Auth0

struct LoginPageView: View {
    
    @State private var isAuthenticated: Bool = false
    @State var userProfile = Profile.empty

    
    var body: some View {
            NavigationView {
                VStack(alignment: .center) {
                    Image("LOGO")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 40)
                    
                    VStack {
                        
                        Button(action: {
                            print("Login button pressed")
                            login()
                        }) {
                          
                                Text("Log In")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .background(Color.blue)
                                    .cornerRadius(15)
                        
                        }
                        .padding([.leading, .trailing], 15)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                    .padding([.leading, .trailing], 5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 40)
                    
                    Spacer()
                    
                    NavigationLink("", destination: MainPageView(),
                                   isActive: $isAuthenticated)
                        .hidden()
                    
                }
                .padding([.leading, .trailing], 20)
            }
            .navigationBarBackButtonHidden(true)
        }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
                    self.userProfile = Profile.from(credentials.idToken)

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

