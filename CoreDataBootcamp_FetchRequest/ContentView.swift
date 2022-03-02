//
//  ContentView.swift
//  CoreDataBootcamp_FetchRequest
//
//  Created by KANISHK VIJAYWARGIYA on 02/03/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    /// RETRIEVE
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)
        ])
    var fruits: FetchedResults<FruitEntity>
    @State var textFieldText: String = ""
    @State var openSheet: Bool = false
    @State var editText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add fruits here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {addItem()}) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                editText = fruit.name ?? ""
                                sheet()
//                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
        .sheet(isPresented: $openSheet) {
            SecondView(newText: $editText)
        }
    }
    /// CRUD
    
    /// CREATE
    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }

    /// UPDATE
    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            saveItems()
        }
    }
    
    /// DELETE
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func sheet() {
        self.openSheet = true
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct SecondView: View {
    @Binding var newText: String
    
    var body: some View {
        TextField("Add fruits here...", text: $newText)
            .font(.headline)
            .padding(.leading)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
