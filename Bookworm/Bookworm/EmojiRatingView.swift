//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by master on 6/7/22.
//

import SwiftUI

struct EmojiRatingView: View {
    
    let rating: Int16
    
    var body: some View {
        switch rating {
        case 1:
            return Text("๐คจ")
        case 2:
            return Text("๐")
        case 3:
            return Text("๐")
        case 4:
            return Text("๐")
        default:
            return Text("๐")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
