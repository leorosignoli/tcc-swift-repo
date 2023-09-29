import SwiftUI
import SDWebImageSwiftUI
import Auth0


struct MyProfileView: View {
    @EnvironmentObject var userProfile: Profile
    let outlookService = OutlookService()


    var body: some View {
        NavigationViewWithSidebar {
        
        VStack(alignment: .leading) {
            
            // Profile Picture
            VStack{
                WebImage(url: URL(string: userProfile.picture))
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                
                GreekLetterAnimatedText(text: "\(userProfile.name)")
                    .padding([.top, .bottom], 10)
                    .font(.headline)
                Divider()
                // Profile Details

                GreekLetterAnimatedText(text: " ε-mail # \(userProfile.email)")
                    .font(.subheadline)
                    .padding([.top, .bottom], 10)

                
                HStack {
                    GreekLetterAnimatedText(text: "Ε-mail Vεrificado? ")
                        .font(.subheadline)

                    if userProfile.emailVerified {
                        GreekLetterAnimatedText(text: "Sim")
                            .font(.subheadline)
                    } else {
                        GreekLetterAnimatedText(text: "Não")
                            .font(.subheadline)
                    }
                }
                
                
                Spacer()
     
                Button("Fazer logout  do outlook"){
                    MSALAuthentication.signout {
                        
                    }
                }
            }.padding()

                
            }
            .padding(30)
            
            
            
                            
    }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
            .environmentObject(Profile.from(Constants.MOCK_TOKEN))
     }
}
