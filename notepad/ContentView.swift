//
//  ContentView.swift
//  notepad
//
//  Created by Hicret Ay on 15.10.2022.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable{
    
    var id: UUID{
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority{
    var title: String{
        switch self{
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allNotes: FetchedResults<Note>
    
    private func saveNote(){
        do{
            let note = Note(context: viewContext)
            note.title = title
            note.priority = selectedPriority.rawValue
            note.dateCreated = Date()
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func styleForPriority(_ value: String) -> Color{
        let priority = Priority(rawValue: value)
        
        switch priority{
        case .low:
            return Color.green
            
        case .medium:
            return Color.orange
            
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    private func updateNote(_ note: Note){
        note.isFavorite = !note.isFavorite
        
        do{
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func deleteNote(at offsets: IndexSet){
        offsets.forEach{
            index in
            let note = allNotes[index]
            viewContext.delete(note)
        }
        
        do{
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter title",text: $title).textFieldStyle(.roundedBorder)
                Picker("Priority", selection: $selectedPriority){
                    ForEach(Priority.allCases){ priority in
                        Text(priority.title).tag(priority)
                        
                    }
                }.pickerStyle(.segmented)
                
                Button("Save"){
                    saveNote()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List{
                    ForEach(allNotes){
                        note in
                        HStack{
                            Circle()
                                .fill(styleForPriority(note.priority!))
                                .frame(width: 15,height: 15)
                            Spacer().frame(width: 20)
                            Text(note.title ?? "")
                            Spacer()
                            Image(systemName: note.isFavorite ? "heart.fill" : "heart").foregroundColor(.red)
                                .onTapGesture {
                                    updateNote(note)
                                }
                        }
                    }.onDelete(perform: deleteNote)
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("All Notes")
        }
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        let persistentContainer = CoreDataManager.shared.persistentContainer
        ContentView()
            .environment(\.managedObjectContext, persistentContainer.viewContext)
    }
}
