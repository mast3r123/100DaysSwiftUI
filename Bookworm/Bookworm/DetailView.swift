//
//  DetailView.swift
//  Bookworm
//
//  Created by master on 6/8/22.
//

import SwiftUI

struct DetailView: View {
    
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("Review")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding([.leading, .top, .bottom])
            
            Text(book.review!.isEmpty ? "No review" : book.review!)
                .font(.title2)
                .padding(.bottom)
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.title2)
            
            Text(formatDate(from: book.date ?? Date.now))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding([.trailing, .top])
            
            
        }
        .navigationTitle(book.title ?? "Unknown book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteBook()
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        dismiss()
    }
    
    func formatDate(from date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: date)
    }
}
