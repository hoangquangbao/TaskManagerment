//
//  NewTask.swift
//  TaskManagerment
//
//  Created by Quang Bao on 13/01/2022.
//

import SwiftUI

struct NewTask: View {
    
    //MARK: Dismiss Add New Task View
    @Environment(\.dismiss) var dismiss
    
    //MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskMode: TaskViewModel
    
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()

    var body: some View {
        
        NavigationView{
            
            List{
                
                Section{
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("TASK TITLE")
                }
                
                Section{
                    TextField("Nothing", text: $taskDescription)
                } header: {
                    Text("TASK DESCRIPTION")
                }
                
                //Disabling Date for Edit Mode
                if taskMode.editTask == nil{
                    Section{
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                    } header: {
                        Text("TASK DATE")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: Disbaling Dismiss on Swipe
            .interactiveDismissDisabled()
            //MARK: Action Button
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        
                        if let task = taskMode.editTask{
                            
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        } else {
                            
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                        }
                        
                        //Saving
                        try? context.save()
                        
                        //Dismissing View
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let task = taskMode.editTask{
                    
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                }
            }
        }
    }
}
