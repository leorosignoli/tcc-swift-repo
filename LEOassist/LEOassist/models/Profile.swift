import Combine
import JWTDecode

class Profile: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var emailVerified: Bool
    @Published var picture: String
    @Published var updatedAt: String
    
    init(name: String, email: String, emailVerified: Bool, picture: String, updatedAt: String) {
        self.name = name
        self.email = email
        self.emailVerified = emailVerified
        self.picture = picture
        self.updatedAt = updatedAt
    }
    
    static let empty = Profile(name: "", email: "", emailVerified: false, picture: "", updatedAt: "")
    
    static func from(_ idToken: String) -> Profile {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let emailVerified = jwt.claim(name: "email_verified").boolean,
            let picture = jwt.claim(name: "picture").string,
            let updatedAt = jwt.claim(name: "updated_at").string
        else {
            return Profile.empty
        }
        
        return Profile(name: name, email: email, emailVerified: emailVerified, picture: picture, updatedAt: updatedAt)
    }
}
