//
//  ImageData+CoreDataProperties.swift
//  Day77
//
//  Created by master on 7/6/22.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

    public var wrappedName: String {
        name ?? "Unknown"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
}

extension ImageData : Identifiable {

}
