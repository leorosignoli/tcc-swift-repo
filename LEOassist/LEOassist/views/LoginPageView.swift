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
                        .padding(.bottom, 160)

                    
                        Button(action: {
                            print("Login button pressed")
                            login()
                        }) {
                          
                                Text("Fazer Log-in")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .background(Color.black)
                                    .cornerRadius(30)
                        
                        }
                        .padding([.leading, .trailing], 20)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 40)
                    
                    Spacer()
                        .frame(height: 60)
                    
                    NavigationLink("", destination: MainPageView(),
                                   isActive: $isAuthenticated)
                        .hidden()
                        .navigationBarItems(leading: EmptyView())
                        .navigationBarBackButtonHidden(true)
                    
                }
                .padding([.leading, .trailing], 20)
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

