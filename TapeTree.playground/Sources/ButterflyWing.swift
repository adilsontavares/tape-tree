import SpriteKit

class ButterflyWing : SKShapeNode {
    
    var size: CGFloat
    var height: CGFloat
    var offset: CGFloat
    
    var color: SKColor = .white {
        didSet {
            updateColor()
        }
    }
    
    init(size: CGFloat, height: CGFloat, offset: CGFloat) {
        
        self.size = size
        self.height = height
        self.offset = offset
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        lineWidth = size * 0.02
        
        updateColor()
        updatePath()
    }
    
    private func updateColor() {
        
        strokeColor = color
        fillColor = color.withAlphaComponent(0.9)
    }
    
    private func updatePath() {
        
        let distortion = size * 1.1
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -size * 0.5, y: 0.0))
        path.addLine(to: CGPoint(x: -size * 0.5 - distortion + offset, y: height))
        path.addLine(to: CGPoint(x: size * 0.5 + distortion + offset, y: height * 0.8))
        path.addLine(to: CGPoint(x: size * 0.5, y: 0.0))
        self.path = path
    }
    
    func animate(withDuration duration: TimeInterval) {
        
        let deltaDuration = duration + TimeInterval(Random.interval01() * CGFloat(duration) * 0.2)
        
        let moveDown = SKAction.scaleY(to: -1.0, duration: deltaDuration)
        moveDown.timingMode = .easeInEaseOut
        
        let moveUp = SKAction.scaleY(to: 1.0, duration: deltaDuration)
        moveUp.timingMode = .easeInEaseOut
        
        let fly = SKAction.sequence([
            moveDown,
            moveUp
        ])
        
        run(SKAction.repeatForever(fly))
    }
    
    func stopAnimation() {
        
        setScale(1.0)
        removeAllActions()
    }
}
