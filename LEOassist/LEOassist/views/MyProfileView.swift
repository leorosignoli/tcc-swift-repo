import SwiftUI
import SDWebImageSwiftUI
import Auth0


struct MyProfileView: View {
    @ObservedObject var userProfile: Profile


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
                
                Text("\(userProfile.name)")
                    .padding([.top, .bottom], 10)
                    .font(.headline)
                Divider()
                // Profile Details

                Text(" Email # \(userProfile.email)")
                    .font(.subheadline)
                    .padding([.top, .bottom], 10)

                
                Text("Email Verificado? ")
                    .font(.subheadline) +
                Text(userProfile.emailVerified ? " Sim" : "Não")
                    .font(.subheadline)
                if(!userProfile.emailVerified ){
                    Spacer()
                    Text("Verificar e-mail")
                        .foregroundColor(.blue)
                }
                
            }
            .padding(30)
            
            
            
            
            Spacer()
            
        }.padding()
    }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView(userProfile : Profile.from(Constants.MOCK_TOKEN))
     }
}
