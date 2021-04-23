//
//  ContentView.swift
//  Shared
//
//  Created by Erik Mikac on 4/17/21.
//

import SwiftUI
import CoreData
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                        }
                    VStack(alignment: .leading) {
                        Text(book.title ?? "Unkown Title")
                            .font(.headline)
                            .foregroundColor(book.rating == 0 ? .red : .black)
                        
                        Text(book.author ?? "Unkown Author")
                            .foregroundColor(book.rating == 0 ? .red : .secondary)
                    }
                 
                    
                }
                .onDelete(perform: deleteBooks)
                
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBookView().environment(\.managedObjectContext, self.moc)
        }
        
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
