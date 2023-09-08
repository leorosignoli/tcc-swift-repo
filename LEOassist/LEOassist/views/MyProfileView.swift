import SwiftUI
import SDWebImageSwiftUI

struct MyProfileView: View {
    @EnvironmentObject var userProfile: Profile


    var body: some View {
        VStack(alignment: .leading) {
            
            // Profile Picture
            WebImage(url: URL(string: userProfile.picture))
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            
            // Profile Details
            Text("Name: \(userProfile.name)")
                .font(.headline)
                .padding(.top, 10)
            
            Text("Email: \(userProfile.email)")
                .font(.subheadline)
            
            Text("Email Verified:")
                            .font(.subheadline) +
                        Text(userProfile.emailVerified ? " Yes" : " No")
                            .font(.subheadline)
                        
            
            Text("Updated At: \(userProfile.updatedAt)")
                .font(.subheadline)
            
            Spacer()
            
        }.padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
