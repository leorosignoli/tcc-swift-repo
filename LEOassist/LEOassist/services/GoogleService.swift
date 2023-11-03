import SwiftUI
import GoogleAPIClientForREST
import GoogleSignIn

class GoogleCalendarManagerService: NSObject, ObservableObject, GIDSignInDelegate {
    @Published var events: [GTLRCalendar_Event] = []
    private let calendarService = GTLRCalendarService()
    
    override init() {
        super.init()
        
        // Configure the Google SignIn
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeCalendar]
        GIDSignIn.sharedInstance().clientID = ApplicationSecrets.GOOGLE_CLIENT_ID
    }
    
    func authenticate() {
        GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - GIDSignInDelegate

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // Set the authenticated user's credentials for the calendar service
        calendarService.authorizer = user.authentication.fetcherAuthorizer()
    }
    
    func fetchEvents() {
        if GIDSignIn.sharedInstance().hasPreviousSignIn() {
            fetchEventsInternal()
        } else {
            authenticate()
        }
    }

    private func fetchEventsInternal() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.orderBy = kGTLRCalendarOrderByStartTime
        
        calendarService.executeQuery(query) { [weak self] (_, result, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }
            
            if let eventsResult = result as? GTLRCalendar_Event {
                print(eventsResult)
                self?.events = [eventsResult]
            }
        }
    }
}
