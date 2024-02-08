import SwiftUI




struct Bugs: View {
    @State private var dragAmount = CGSize.zero
    @State private var draggedState = DraggedState.undefined
    
    //THIS
    var name: String
    var index: Int
    
    var onChanged: ((CGPoint, String) -> DraggedState)?
    var onEnded: ((CGPoint, Int, String) -> Void)?
    
    var dragColor: Color {
        
        switch draggedState {
        case .undefined: return .black
        case .matched: return .green
        case .wrong: return .red
        }
    }
    
    var body: some View {
        
        Image(systemName: name)
            .resizable()
            .frame(width: 80, height: 80)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged{
                        self.dragAmount = CGSize(width:$0.translation.width, height: $0.translation.height)
                        self.draggedState = self.onChanged?($0.location, self.name) ?? .undefined
                    }
                    .onEnded {
                        if self.draggedState == .matched {
                            self.onEnded?($0.location, self.index, self.name)
                        }
                        self.dragAmount = .zero
                    }
            
            )
        
    }
    
    
    
}
