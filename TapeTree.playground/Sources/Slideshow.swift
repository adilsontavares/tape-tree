import SpriteKit

class Slideshow : SKNode {
    
    private(set) var content: [String]
    private(set) var index = 0
    
    var label: SKLabelNode
    
    init(content: [String]) {
        
        self.content = content
        
        label = SKLabelNode(fontNamed: "Helvetica")
        label.fontSize = 30.0
        label.color = SKColor.white.withAlphaComponent(0.7)
        label.colorBlendFactor = 0.5
        label.alpha = 0.0
        
        super.init()
        
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        
        index = -1
        animateNext()
    }
    
    private func animateNext() {
        
        index += 1
        
        if index >= content.count {
            return
        }
        
        let transitionDuration: TimeInterval = 2.0
        let textDuration: TimeInterval = TimeInterval(max(3.0, (CGFloat(strlen(content[index])) / 15.0) * 2.0))
        
        let offset: CGFloat = 10.0
        var actions = [SKAction]()
        
        label.alpha = 0.0
        label.text = content[index]
        label.position = CGPoint(x: 0.0, y: -offset)
        
        actions.append(SKAction.group([
            SKAction.fadeIn(withDuration: transitionDuration),
            SKAction.moveBy(x: 0.0, y: offset, duration: transitionDuration)
        ]))
        
        actions.append(SKAction.wait(forDuration: textDuration))
        
        actions.append(SKAction.group([
            SKAction.fadeOut(withDuration: transitionDuration),
            SKAction.moveBy(x: 0.0, y: -offset, duration: transitionDuration)
        ]))
        
        actions.append(SKAction.run {
            self.animateNext()
        })
        
        label.run(SKAction.sequence(actions))
    }
}

