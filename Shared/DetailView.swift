//
//  DetailView.swift
//  BookWorm
//
//  Created by Erik Mikac on 4/21/21.
//

import SwiftUI
import CoreData


struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    let formatter = DateFormatter()
 
    var body: some View {
        formatter.dateFormat = "E, MMMM dd yyyy @ hh:mm aaa"
        return GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                  
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
     
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.author ?? "Unkown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text("Review Created: \(formatter.string(from: self.book.date ?? Date()))")
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unkown Title"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
        // try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Great book!"
        return NavigationView {
            DetailView(book: book)
        }
       
    }
}
