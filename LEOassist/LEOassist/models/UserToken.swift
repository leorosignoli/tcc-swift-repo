import SwiftUI
import Combine

class UserToken: ObservableObject {
    @Published var idToken: String = ""
}
