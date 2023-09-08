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
        guard let jwt = try? decode(jwt: idToken) else {
            print("Failed to decode JWT")
            return Profile.empty
        }

        guard let name = jwt.claim(name: "name").string else {
            print("Error: Name not found in the JWT")
            return Profile.empty
        }

        guard let email = jwt.claim(name: "email").string else {
            print("Error: Email not found in the JWT")
            return Profile.empty
        }

        guard let emailVerified = jwt.claim(name: "email_verified").boolean else {
            print("Error: Email verification status not found in the JWT")
            return Profile.empty
        }

        guard let picture = jwt.claim(name: "picture").string else {
            print("Error: Picture not found in the JWT")
            return Profile.empty
        }

        guard let updatedAt = jwt.claim(name: "updated_at").string else {
            print("Error: Updated At not found in the JWT")
            return Profile.empty
        }

        return Profile(name: name, email: email, emailVerified: emailVerified, picture: picture, updatedAt: updatedAt)
    }
    
    func update(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken) else {
            print("Failed to decode JWT")
            return
        }

        if let name = jwt.claim(name: "name").string {
            self.name = name
        } else {
            print("Error: Name not found in the JWT")
        }

        if let email = jwt.claim(name: "email").string {
            self.email = email
        } else {
            print("Error: Email not found in the JWT")
        }

        if let emailVerified = jwt.claim(name: "email_verified").boolean {
            self.emailVerified = emailVerified
        } else {
            print("Error: Email verification status not found in the JWT")
        }

        if let picture = jwt.claim(name: "picture").string {
            self.picture = picture
        } else {
            print("Error: Picture not found in the JWT")
        }

        if let updatedAt = jwt.claim(name: "updated_at").string {
            self.updatedAt = updatedAt
        } else {
            print("Error: Updated At not found in the JWT")
        }
    }
}
