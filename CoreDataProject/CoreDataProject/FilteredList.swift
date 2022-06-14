//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by master on 6/14/22.
//

import SwiftUI

struct FilteredList: View {
    
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text(singer.wrappedFirstName + " " + singer.wrappedLastName)
        }
    }
    
    init(filterString: String) {
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filterString))
    }
}
