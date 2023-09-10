import SwiftUI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium // controls the format of the date
    formatter.timeStyle = .short // controls the format of the time
    return formatter
}()
