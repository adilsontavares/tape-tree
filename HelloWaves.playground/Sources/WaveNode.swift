import SpriteKit

class WaveNode : SKShapeNode {
    
    var velocity: CGFloat = 0.0
    
    var origin: CGPoint = .zero
    var destination: CGPoint = .zero
    
    override var position: CGPoint {
        didSet {
            destination = position
        }
    }
    
    var radius: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    init(radius: CGFloat) {
        
        self.radius = radius
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        strokeColor = .clear
        fillColor = .blue
        
        updatePath()
    }
    
    func updatePhysics(left: WaveNode?, right: WaveNode?) {
        
        if let left = left {
            velocity += (left.destination.y - destination.y)
        }
        
        if let right = right {
            velocity += (right.destination.y - destination.y)
        }
    }
    
    func updateDestination() {
        
        origin = destination
        destination.y += velocity
    }
    
    func update(withTime time: CGFloat) {
        position = destination
    }
    
    func reset() {
        
        velocity = 0.0
        origin = position
        destination = position
    }
    
    private func updatePath() {
        
        let path = CGPath(ellipseIn: CGRect.zero.insetBy(dx: -radius, dy: -radius), transform: nil)
        self.path = path
    }
}
