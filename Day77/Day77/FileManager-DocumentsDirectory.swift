//
//  FileManager-DocumentsDirectory.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
