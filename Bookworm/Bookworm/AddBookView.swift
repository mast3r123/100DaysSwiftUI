//
//  AddBookView.swift
//  Bookworm
//
//  Created by master on 6/7/22.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    @State private var showInvalidInputAlert = false
    @State private var errorMessage = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if validateInputs() {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add book")
            .alert("Oops!", isPresented: $showInvalidInputAlert) {
                Button("Ok") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func validateInputs() -> Bool {
        if title.isEmpty {
            errorMessage = "Please enter a valid title"
            showInvalidInputAlert.toggle()
            return false
        } else if author.isEmpty {
            errorMessage = "Please enter a valid author"
            showInvalidInputAlert.toggle()
            return false
        } else if genre.isEmpty {
            errorMessage = "Please select a valid genre"
            showInvalidInputAlert.toggle()
            return false
        }
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
