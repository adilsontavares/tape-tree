import Foundation
import SpriteKit
import PlaygroundSupport

public class Application : NSObject {
    
    let view: SKView
    let scene: GameScene
    
    public init(size: CGSize) {
        
        scene = GameScene(size: size)
        
        view = SKView(frame: CGRect(origin: .zero, size: size))
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        view.presentScene(scene)
        
        super.init()
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
    }
    
    public func run() {
     
    }
}
