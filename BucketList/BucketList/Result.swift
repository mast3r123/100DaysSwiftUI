//
//  Result.swift
//  BucketList
//
//  Created by master on 7/2/22.
//

import Foundation

struct Result: Codable {
    let query: Query
}


struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.pageid == rhs.pageid
    }
    
    let pageid: Int
    let title: String
    let thumbnail: Thumbnail?
    let terms: Terms?
    
    var description: String {
        terms?.termsDescription?.first ?? "No further information"
    }
        
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    enum CodingKeys: String, CodingKey {
        case pageid
        case title
        case thumbnail
        case terms
    }
}

struct Terms: Codable {
    let termsDescription: [String]?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let source: String?
    let width, height: Int?
}
