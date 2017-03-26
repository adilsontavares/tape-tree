import SpriteKit
import PlaygroundSupport
import AVFoundation

public class Application : NSObject {
    
    let size = CGSize(width: 800, height: 600)
    private let intro: IntroScene
    
    override public init() {
        
        intro = IntroScene(size: size)
        
        super.init()
    }
    
    public func run() {
        
        let view = SKView(frame: NSRect(origin: .zero, size: size))
//        view.showsFPS = true
//        view.showsNodeCount = true
        view.presentScene(intro)
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
    }
}
