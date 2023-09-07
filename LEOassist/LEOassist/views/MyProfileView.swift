import SwiftUI
import SDWebImageSwiftUI

struct MyProfileView: View {
    @State var profile: Profile

    var body: some View {
        VStack(alignment: .leading) {
            
            // Profile Picture
            WebImage(url: URL(string: profile.picture))
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            
            // Profile Details
            Text("Name: \(profile.name)")
                .font(.headline)
                .padding(.top, 10)
            
            Text("Email: \(profile.email)")
                .font(.subheadline)
            
            Text("Email Verified: \(profile.emailVerified)")
                .font(.subheadline)
            
            Text("Updated At: \(profile.updatedAt)")
                .font(.subheadline)
            
            Spacer()
            
        }.padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView(profile: Profile.from(Constants.mockToken))
    }
}
