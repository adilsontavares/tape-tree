import SpriteKit

class Butterfly : SKShapeNode {
    
    private(set) var wings = [ButterflyWing]()
    
    var size: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    var color = SKColor(hue: 0.34, saturation: 0.8, brightness: 1.0, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    init(size: CGFloat) {
        
        self.size = size
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        lineWidth = 3.0
        strokeColor = .clear
        
        updatePath()
        
        let backPoint = CGPoint.zero//(x: -size * 0.25, y: 0.0)
        let frontPoint = CGPoint.zero//(x: size * 0.25, y: 0.0)
        
        let backRotation: CGFloat = -CGFloat.pi * 0.1
        let frontRotation: CGFloat = CGFloat.pi * 0.1
        
        createWing(at: backPoint, size: size * 0.4, height: size * 0.6, offset: size * 0.3, rotation: backRotation)
        createWing(at: frontPoint, size: size * 0.6, height: size * 0.9, offset: size * 0.3, rotation: frontRotation)
        
        createWing(at: backPoint, size: size * 0.4, height: size * 0.6, offset: -size * 0.3, rotation: backRotation)
        createWing(at: frontPoint, size: size * 0.6, height: size * 0.9, offset: -size * 0.3, rotation: frontRotation)
        
        updateWings()
        updateColors()
    }
    
    private func updateColors() {
        
        let dist: CGFloat = 0.2
        
        fillColor = color
        
        for i in 0 ..< wings.count {
            
            let wing = wings[i]
            let ratio = CGFloat(i) / CGFloat(wings.count - 1)
            
            wing.color = SKColor(hue: modf(color.hueComponent + ratio * dist + 0.07).1, saturation: color.saturationComponent, brightness: color.brightnessComponent, alpha: 1.0)
        }
    }
    
    private func updateWings() {
        
        for i in 0 ..< wings.count {
            
            let wing = wings[i]
            let ratio = CGFloat(i) / CGFloat(wings.count - 1)
            
            wing.color = SKColor(hue: ratio * 0.3, saturation: 0.7, brightness: 0.9, alpha: 1.0)
        }
    }
    
    @discardableResult private func createWing(at point: CGPoint, size: CGFloat, height: CGFloat, offset: CGFloat, rotation: CGFloat) -> ButterflyWing {
        
        let wing = ButterflyWing(size: size, height: height, offset: offset)
        wing.position = point
        wing.zRotation = rotation
        addChild(wing)
        
        wings.append(wing)
        
        return wing
    }
    
    private func updatePath() {
        
        let height = floor(size * 0.15)
        
        let path = CGPath(roundedRect: CGRect(x: -size * 0.5, y: -height * 0.5, width: size, height: height), cornerWidth: height * 0.4, cornerHeight: height * 0.4, transform: nil)
        self.path = path
    }
    
    func animate(withDuration duration: TimeInterval) {
        
        for wing in wings {
            wing.animate(withDuration: duration)
        }
        
        let shakeDuration = duration * 2.0
        let rotationDuration = duration * 2.0
        
        let rotateDown = SKAction.rotate(toAngle: CGFloat.pi * 0.02, duration: rotationDuration * 0.6)
        rotateDown.timingMode = .easeInEaseOut
        
        let rotateUp = SKAction.rotate(toAngle: -CGFloat.pi * 0.02, duration: rotationDuration * 0.4)
        rotateUp.timingMode = .easeInEaseOut
        
        let rotate = SKAction.repeatForever(SKAction.sequence([
            rotateDown, rotateUp
        ]))
        
        let moveDown = SKAction.moveBy(x: 0, y: size * 0.1, duration: shakeDuration * 0.5)
        moveDown.timingMode = .easeInEaseOut
        
        let moveUp = SKAction.moveBy(x: 0, y: -size * 0.1, duration: shakeDuration * 0.5)
        moveUp.timingMode = .easeInEaseOut
        
        let move = SKAction.repeatForever(SKAction.sequence([
            moveDown, moveUp
        ]))
        
        run(SKAction.group([
            rotate, move
        ]))
    }
    
    func stopAnimation() {
        
        removeAllActions()
        
        for wing in wings {
            wing.stopAnimation()
        }
    }
}
