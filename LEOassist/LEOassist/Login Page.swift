import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Image("LOGO")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 40)
            
            VStack {
                TextField("Digite seu e-mail", text: $username)
                    .padding()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.init(.label), lineWidth: 0.5))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding([.leading, .trailing], 15)
                    
                
                SecureField("Digite sua senha", text: $password)
                    .padding()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.init(.label), lineWidth: 0.5))
                    .padding([.leading, .trailing], 15)
                
                Button(action: {
                    print("Login button pressed")
                }) {
                    NavigationLink(destination: MainPage()) {
                        Text("Log In")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                    .disabled(!isValidEmail(testStr: username) || password.isEmpty)
                    .opacity((isValidEmail(testStr: username) && !password.isEmpty) ? 1 : 0.6)
                }
                .padding([.leading, .trailing], 15)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 5)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 40)
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
