import SpriteKit

public class GameScene : SKScene {
    
    let wave: Wave
    
    override public init(size: CGSize) {
        
        wave = Wave(length: size.width, nodeCount: 20)
        wave.position = CGPoint(x: 0, y: size.height * 0.5)
        
        super.init(size: size)
        
        addChild(wave)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
        let speed: CGFloat = 1.0
        let time: CGFloat = sin(CGFloat(currentTime) * 2.0 * CGFloat.pi * speed)
        let offset = time * 100.0
        
        if let firstNode = wave.nodes.first {
            firstNode.position = CGPoint(x: 0.0, y: offset)
        }
        
        wave.update()
        
        if let firstNode = wave.nodes.first {
            firstNode.position = CGPoint(x: 0.0, y: offset)
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        
        print("RESET")
        wave.reset()
    }
}
