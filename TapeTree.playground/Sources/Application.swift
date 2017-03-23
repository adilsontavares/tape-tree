import SpriteKit
import PlaygroundSupport

public class Application : NSObject {
    
    var rootBranch: Branch!
    
    var scene: SKScene! = nil
    var view: SKView! = nil
    let size = CGSize(width: 800, height: 600)
    
    public func run() {
        
        scene = SKScene(size: size)
        view = SKView(frame: NSRect(origin: .zero, size: size))
        view.showsFPS = true
        view.showsNodeCount = true
        view.presentScene(scene)
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
        
        self.reset()
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { _ in
            self.reset()
        }
        
        let backgroundOffset: CGFloat = Random.value()
        let backgroundDuration: TimeInterval = 50.0
        let backgroundAction = SKAction.customAction(withDuration: backgroundDuration, actionBlock: { (node, time) in
            (node as! SKScene).backgroundColor = SKColor(hue: modf(backgroundOffset + time / CGFloat(backgroundDuration)).1, saturation: 0.4, brightness: 0.21, alpha: 1.0)
        })
        
        scene.run(SKAction.repeatForever(backgroundAction))
    }
    
    private func reset() {
        
        self.createRoot()
        self.rootBranch.grow(withDuration: 3.0)
        
        Timer.scheduledTimer(withTimeInterval: 3.8, repeats: false, block: { _ in
            self.rootBranch.decrease(withDuration: 2.0)
        })
    }
    
    private func createRoot() {
        
        if let branch = rootBranch {
            branch.removeFromParent()
        }
        
        rootBranch = Branch.createTree(withDepth: Config.maxDepth, color: SKColor(hue: modf(self.scene.backgroundColor.hueComponent + 0.5).1, saturation: Random.interval(from: 0.5, to: 1.0), brightness: Random.interval(from: 0.5, to: 1.0), alpha: 1.0))
        rootBranch.position = CGPoint(x: size.width * 0.5, y: 0.0)
        scene.addChild(rootBranch)
    }
}
