//
//  CalendarView.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 15/09/23.
//

import SwiftUI


struct CalendarView: UIViewRepresentable{
    
    @Binding var selectedDate : Date?
    @Binding var selectedDateEvents : [Event]
    @EnvironmentObject var userProfile : Profile


    var dateInterval : DateInterval{
        
        let calendar = Calendar.current
        guard
            let firstDayOfmonth = calendar.date(from: calendar.dateComponents([.month, .year], from: Date())),
            let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfmonth),
            let lastDayOfMonth = calendar.date(byAdding: .day, value: 1, to: firstDayOfNextMonth)
        else {
            return DateInterval()
        }
         return DateInterval(start: firstDayOfmonth, end: lastDayOfMonth )
                    
                
    }
    
    func makeCoordinator() ->  CalendarCoordinator {
        CalendarCoordinator(calendarIdentifier: .gregorian, selectedDate: $selectedDate, eventsForDate: $selectedDateEvents, userProfile: userProfile)

    }
    
    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .secondarySystemBackground
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.wantsDateDecorations = true
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let calendar = Calendar(identifier: .gregorian)

        uiView.calendar = calendar
        uiView.availableDateRange = dateInterval
        context.coordinator.calendarIdentifier = .gregorian
    }
}
final class CalendarCoordinator: NSObject, UICalendarSelectionSingleDateDelegate{
    
    var userProfile : Profile
    var calendarIdentifier : Calendar.Identifier = .gregorian
    @Binding var selectedDate : Date?
    @Binding var eventsForDate : [Event]
    
    
    var calendar: Calendar {
       Calendar(identifier: calendarIdentifier)
     }
    
    init(calendarIdentifier : Calendar.Identifier, selectedDate: Binding<Date?>, eventsForDate : Binding<[Event]>, userProfile: Profile) {
        self._selectedDate = selectedDate
        self.calendarIdentifier = calendarIdentifier
        self._eventsForDate = eventsForDate
        self.userProfile = userProfile
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        guard
            dateComponents != nil
        else { return false }
            return true
          }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard
              let dateComponents,
              let date = calendar.date(from: dateComponents)
            else { return }
            self.selectedDate = date
                
        EventsService.fetchEventsFromDay(owner: self.userProfile.email, day: backEndpiDateWithoutTimeFormatter.string(from: selectedDate!)) { events in
            self.eventsForDate = events
            }
    }
}
 
