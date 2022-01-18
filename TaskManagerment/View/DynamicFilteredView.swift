//
//  DynamicFilteredView.swift
//  TaskManagerment
//
//  Created by Quang Bao on 13/01/2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View where T: NSManagedObject {
    
    //MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    //MARK: Building Custom ForEach which will give CoreData object to build View
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T)->Content){
        
        //MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateToFilter)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        
        //Filter Key
        let filterKey = "taskDate"
        
        //This will fetch task between today and tommorow which is 24 HRS
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tomorrow])
        
        //Intializing Request With NSPredicate
        //Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        
        Group{
            if request.isEmpty {
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                }
            }
        }
    }
}

