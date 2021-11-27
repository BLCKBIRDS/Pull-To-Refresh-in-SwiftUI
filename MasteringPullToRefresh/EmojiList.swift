//
//  EmojiList.swift
//  MasteringPullToRefresh
//
//  Created by Work on 27.11.21.
//

import SwiftUI

struct EmojiList: View {
    
    @State var emojiSet = [String]()
    
    var body: some View {
        NavigationView {
            List(emojiSet, id: \.self) { emoji in
                Text(emoji)
            }
                .refreshable {
                    emojiSet = createRandomEmojiSet()
                }
                .navigationTitle("Random Emojis")
                .onAppear {
                    emojiSet = createRandomEmojiSet()
                }
        }
    }
    
    func createRandomEmojiSet() -> [String] {
        
        var emojiSet = [String]()
        
        for _ in 1...10 {
            let range = [UInt32](0x1F601...0x1F64F)
            let ascii = range[Int(drand48() * (Double(range.count)))]
            let emoji = UnicodeScalar(ascii)?.description
            emojiSet.append(emoji!)
        }
        
        return emojiSet
    }
}

struct EmojiList_Previews: PreviewProvider {
    static var previews: some View {
        EmojiList()
    }
}
