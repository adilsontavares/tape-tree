import SpriteKit

class TimerScene : SKScene {
    
    let label = SKLabelNode(text: "Scholarship")
    var target: TimeInterval = 0.0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(label)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            
            let next = GameScene(size: self.size)
            self.view?.presentScene(next, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
