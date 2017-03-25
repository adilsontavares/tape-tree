import SpriteKit

class TreeSwing : SKShapeNode {
    
    var seat: TreeSwingSeat
    var ropes = [TreeSwingRope]()
    
    var length: CGFloat {
        didSet {
            for rope in ropes {
                rope.length = length
            }
        }
    }
    
    var nodeCount: Int {
        didSet {
            for rope in ropes {
                rope.nodeCount = nodeCount
            }
        }
    }
    
    var width: CGFloat {
        didSet {
            updateRopes()
        }
    }
    
    var rotation: CGFloat = 0 {
        didSet {
            updateRopes()
        }
    }
    
    init(length: CGFloat, nodeCount: Int, width: CGFloat) {
        
        self.length = length
        self.nodeCount = nodeCount
        self.width = width
        self.seat = TreeSwingSeat(width: width, depth: width * 0.2, distortion: width * 0.07)
        
        super.init()
        
        addChild(seat)
        
        createRope(at: .zero)
        createRope(at: .zero)
        
        updateRopes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult private func createRope(at point: CGPoint) -> TreeSwingRope {
        
        let rope = TreeSwingRope(length: length, nodeCount: nodeCount)
        rope.position = point
        addChild(rope)
        
        ropes.append(rope)
        
        return rope
    }
    
    private func updateRopes() {
 
        var position = CGPoint(x: -width * 0.5, y: 0.0)
        let delta = CGPoint(x: width / CGFloat(ropes.count - 1), y: 0.0)
        
        if ropes.isEmpty {
            return
        }
        
        for rope in ropes {
            
            rope.position = position
            rope.rotation = rotation
            
            position.x += delta.x
            position.y += delta.y
        }
        
        seat.position = CGPoint(
            x: (ropes[0].endPoint.x + ropes[1].endPoint.x) * 0.5,
            y: (ropes[0].endPoint.y + ropes[1].endPoint.y) * 0.5
        )
    }
    
    func startAnimation(withDuration duration: TimeInterval, rotation: CGFloat) {
        
        let deltaDuration = duration * 0.5
        
        let intro = SKAction.customAction(withDuration: deltaDuration) { node, time in
            self.rotation = CGFloat.lerp(from: 0, to: rotation, time: time / CGFloat(deltaDuration))
        }
        
        let left = SKAction.customAction(withDuration: deltaDuration) { node, time in
            self.rotation = CGFloat.lerp(from: rotation, to: -rotation, time: time / CGFloat(deltaDuration))
        }
        
        let right = SKAction.customAction(withDuration: deltaDuration) { node, time in
            self.rotation = CGFloat.lerp(from: -rotation, to: rotation, time: time / CGFloat(deltaDuration))
        }
        
        let timingMode = SKActionTimingMode.easeInEaseOut
        intro.timingMode = timingMode
        right.timingMode = timingMode
        left.timingMode = timingMode
        
        let actions = SKAction.sequence([
            intro,
            SKAction.repeatForever(SKAction.sequence([
                left, right
            ]))
        ])
        
        run(actions)
    }
}
