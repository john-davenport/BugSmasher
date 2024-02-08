import SwiftUI

struct GameNumber: View {
    
    var text: String
    var value: Int
    
    var body: some View {
        VStack {
            Text(text)
            Text("\(value)")
                .font(.largeTitle)
        }
    }
}
