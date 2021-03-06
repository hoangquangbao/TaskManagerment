//
//  Home.swift
//  TaskMangermentApp
//
//  Created by Quang Bao on 09/01/2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel = TaskViewModel()
    @Namespace var animation
    
    //MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    //MARK: Edit Button
    @Environment(\.editMode) var editButton
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            
            //MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section{
                    
                    //MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        WeekView()
                    }
        
                    TasksView()
                    
                } header: {
                    
                    HeaderView()
                }
            }
        }
//        .ignoresSafeArea()
//        .padding(.top, 10)
        
        
        //.ignoresSafeArea(.container, edges: .top)
        //or
        .edgesIgnoringSafeArea(.top)
        //or
        //.ignoresSafeArea()
        .overlay(
            
            VStack{
                Button(action: {
                    taskModel.isAddNewTask.toggle()
                }, label: {
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.yellow, in: Circle())
                })
                                
                Button(action: {
                }, label: {
                    
                    Image(systemName: "slider.vertical.3")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.yellow, in: Circle())
                })
            }
                .padding()
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.isAddNewTask) {
            // Clearing Edit Data
            taskModel.editTask = nil
        } content: {
            NewTask()
                .environmentObject(taskModel)
        }

    }
    
    //MARK: HeaderView
    func HeaderView() -> some View {
        
        HStack(spacing: 10){
            
            VStack(alignment: .leading, spacing: 10){
                //Using .omitted that it's mean excludes the time part
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            EditButton()

//            Button {
//
//            } label: {
//
//                Image("Profile")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 45, height: 45)
//                    .clipShape(Circle())
//                    .background(
//                        Circle()
//                            .stroke(.black, lineWidth: 1)
//                    )
//            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(.white)
    }
    
    //MARK: WeekView
    func WeekView() -> some View {
        
        HStack(spacing: 10){
            
            ForEach(taskModel.currentWeek, id: \.self){day in
                
                VStack(spacing: 10){
                    
                    Text(taskModel.extractDate(date: day, format: "dd"))
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                    
//                                Text(day.formatted(date: .abbreviated, time: .omitted))
                    // EEE will return day as Mon, Tue,...etc
                    Text(taskModel.extractDate(date: day, format: "EEE"))
                        .font(.system(size: 14))
                    
                    if (taskModel.isToday(date: day)){
                        Circle()
                            .frame(width: 8, height: 8)
                        //                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                    }
                }
                //MARK: Foreground Style
                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
//                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)

                //MARK: Capsule Shape
                .frame(width: 45, height: 90)
                .background(
                    
                    ZStack{
                        //MARK: Matched Geometry Effect
                        if taskModel.isToday(date: day){
                            Capsule()
                                .fill(.yellow)
                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                        }
                    }
                )
                .contentShape(Capsule())
                .onTapGesture {
                    //Updating Current Day
                    withAnimation {
                        taskModel.currentDay = day
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    //MARK: TasksView
    func TasksView() -> some View {
        
        LazyVStack(spacing: 18){
            
//            if let tasks = taskModel.filteredTasks {
//
//                if tasks.isEmpty {
//
////                    Text("No tasks found!!!")
////                        .font(.system(size: 16))
////                        .fontWeight(.light)
////                        .offset(y: 100)
//                } else {
//
//                    ForEach(tasks){ task in
//                        TaskCardView(task: task)
//                    }
//                }
//            } else {
//
//                //MARK: Progress View
//                ProgressView()
//                    .offset(y: 100)
//            }
            
            //Converting object as Our Task Model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    //MARK: TaskCardView
    func TaskCardView(task: Task) -> some View {
        
        //MARK: Since CoreData Values will give optinal data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30){
            
            // If Edit mode enable then showing Delete Button
            if editButton?.wrappedValue == .active{
                
                // Edit Button
//                VStack{
//                    Button {
//
//                    } label: {
//
//                        Image(systemName: "pencil")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(width: 25, height: 25)
//                            .background(
//                                Circle()
//                                    .fill(.black)
//                            )
//                            //.background(Color.black, in: Circle())
//                    }
//
//                    Button {
//                        //MARK: Deleting Task
//                        context.delete(task)
//
//                        // Saving
//                        try? context.save()
//
//                    } label: {
//
//                        Image(systemName: "minus")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(width: 25, height: 25)
//    //                        .background(
//    //                            Circle()
//    //                                .fill(.black)
//    //                        )
//                            .background(Color.red, in: Circle())
//                    }
//                }
                
                VStack(spacing: 10){
                    
//                    if (task.taskDate ?? Date()) >= Date(){
//                    if task.taskDate?.compare(Date()) == .orderedDescending || taskModel.isToday(date: task.taskDate ?? Date()){
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        Button {
                            
                            taskModel.editTask = task
                            taskModel.isAddNewTask.toggle()
                        } label: {
                            
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        //MARK: Deleting Task
                        context.delete(task)
                        
                        // Saving
                        try? context.save()
                        
                    } label: {
                        
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            } else {
                
                VStack(spacing: 10){
                    Circle()
                        .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompleted ? .green : .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .padding(-3)
                        )
                        .scaleEffect(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0.6)
                             
                    //Make line to connect in list
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                }
            }
            
            VStack{
                
                HStack(alignment: .top, spacing: 10){
                    
                    //MARK: Content
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
//                    .hLeading()
                    
                    //MARK: Time
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                        .hTrailing()
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()){
                    //MARK: Team Members
                    HStack(spacing: 12){
                        
//                        HStack(spacing: -10){
//
//                            ForEach(["User1", "User2", "User3"], id: \.self){ user in
//                                Image(user)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 45, height: 45)
//                                    .clipShape(Circle())
//                                    .background(
//                                        Circle()
//                                            .stroke(.black, lineWidth: 1)
//                                    )
//                            }
//                        }
//                        .hLeading()
                        
                        //MARK: Check Button
                        if !task.isCompleted{
                            Button {
                                //Updating Checkmark
                                task.isCompleted = true
                                
                                //Saving
                                try? context.save()
                            } label: {
                                
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
        //                            .background(
        //                                Color.white
        //                                    .cornerRadius(10)
        //                            )
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Mark as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .white)
                            .hLeading()

                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.vertical, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 10 : 0)
            //.hLeading()
            .background(
                Color("BG")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            )
        }
        .hLeading()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            //.previewDisplayName("iPhone 12 Pro")
    }
}

//MARK: UI Design Helper fuctions
extension View{
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero}
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
}
