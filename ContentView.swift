import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var gameData: GameData
    
    @State private var activeBugs = [String](repeating: "ladybug.fill", count: 3)
    @State private var playerBugs = [String](repeating: "ladybug.fill", count: 4)
    @State private var dropZones = [CGRect](repeating: .zero, count: 3)
    
    @State private var timeRemaining = 5
    @State private var score = 0
    
    @State private var isGameOver = false
    
    let possibleBugs = ["ladybug.fill", "ant.fill", "tortoise.fill"]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            
            //Title
            VStack {
                Text("Bug Matcher")
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .font(.title)
                HStack{
                GameNumber(text: "Time", value: timeRemaining)
                GameNumber(text: "Score", value: gameData.score)
            }
            }
            
            HStack {
            
                ForEach(0..<2) { number in 
                    Bugs(name: self.activeBugs[number], index: number) 
                        .allowsHitTesting(false)
                        .foregroundColor(.teal)
                        .overlay{
                            GeometryReader { geo in 
                                Color.clear
                                    .onAppear{
                                        self.dropZones[number] = geo.frame(in: .global)
                                    }
                            }
                        }
                }
            }
            Spacer()
            
            
            HStack {
                
                ForEach(0..<3) { number in 
                    Bugs(name: self.playerBugs[number], index: number, onChanged: self.bugMoved, onEnded: self.bugDropped)
                        .foregroundColor(.yellow)
                }
            }
            
            Button {
                shuffleActiveBugs()
            } label: {
                Image(systemName: "shuffle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.cyan)
                    .padding(.top, 25)
            }
            
            Spacer()
            
            
        }
        .frame(width: 500, height: 500)
        .onAppear(perform: startGame)
        .background(Image("Background"))
        .onReceive(timer) { value in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                if timeRemaining <= 0 {
                    isGameOver = true
                }
            }
        }
        .sheet(isPresented: $isGameOver, onDismiss: {
            gameData.score = 0
            timeRemaining = 5
        }, content: {
            GameOver(score: gameData)
        })
    }
    
    func startGame() {
        
        activeBugs = (1...2).map { _ in self.randomBug() }
        playerBugs = (1...3).map { _ in self.randomBug() }
        
    }
    //I think this is for coloring the state on hover
    func bugMoved(location: CGPoint, name: String) -> DraggedState {
        
        if let match = dropZones.firstIndex(where: { $0.contains(location) }) {
            if activeBugs[match] == name {
                return .matched
            } else {
                return .wrong
            }
        } else {
            return .undefined
        }
    }
    
    func bugDropped(location: CGPoint, index: Int, name: String) {
        
        if let match = dropZones.firstIndex(where: { 
            $0.contains(location) }) {
            activeBugs[match] = name
            
            playerBugs.remove(at: index)
            playerBugs.append(randomBug())
            
            activeBugs.remove(at: match)
            activeBugs.append(randomBug())
            
            gameData.score += 10
            timeRemaining += 2
            
        }
    }
    
    func shuffleActiveBugs() {
        
        activeBugs = (1...2).map { _ in self.randomBug() }
        playerBugs = (1...3).map { _ in self.randomBug() }
        
    }
    
    func randomBug() -> String {
        
        let randomElement = possibleBugs.randomElement()
        
        return randomElement ?? "pencil"
        
    }
}
