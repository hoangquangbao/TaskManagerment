//
//  TaskViewModel.swift
//  TaskMangermentApp
//
//  Created by Quang Bao on 09/01/2022.
//

import SwiftUI

class TaskViewModel: ObservableObject{
    
    //Current Week Days
    @Published var currentWeek: [Date] = []
    
    //Current Day
    @Published var currentDay: Date = Date()
    
    //Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    //MARK: New Task View
    @Published var isAddNewTask: Bool = false
    
    //MARK: Initializing
    init(){
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
//        ForEach(1...7, id: \.self) { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    //MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    //MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
