//
//  GameOver.swift
//  My App
//
//  Created by John Davenport on 11/1/22.
//

import SwiftUI

struct GameOver: View {
    
    @ObservedObject var score: GameData
    
    var body: some View {
        
        VStack {
            Text("Game Over")
            Text("Score: \(score.score)")
        }
        
    }
    
}
