import SpriteKit
import PlaygroundSupport
import AVFoundation

public class Application : NSObject {
    
    let size = CGSize(width: 800, height: 600)
    
    override public init() {
        super.init()
    }
    
    public func run() {
        
        let view = SKView(frame: NSRect(origin: .zero, size: size))
//        view.showsFPS = true
//        view.showsNodeCount = true
//        view.showsDrawCount = true
        
        let scene = GameScene(size: size)
        view.presentScene(scene)
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
    }
}
