import SpriteKit

class TreeSwingRope : SKShapeNode {
    
    var length: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    var nodeCount: Int {
        didSet {
            updatePath()
        }
    }
    
    var rotation: CGFloat = 0.0 {
        didSet {
            updatePath()
        }
    }
    
    private(set) var endPoint: CGPoint = .zero
    
    init(length: CGFloat, nodeCount: Int) {
        
        self.length = length
        self.nodeCount = nodeCount
        
        assert(nodeCount > 0)
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        lineWidth = 4.0
        strokeColor = .white
        
        updatePath()
    }
    
    private func updatePath() {
     
        let path = CGMutablePath()
        let deltaLength = length / CGFloat(nodeCount)
        let deltaAngle = rotation / CGFloat(nodeCount)
        
        var lastPoint = CGPoint.zero
        var angle = CGFloat.pi * 1.5
        
        path.move(to: .zero)
        
        for _ in 0 ..< nodeCount {
            
            let dx = cos(angle) * deltaLength
            let dy = sin(angle) * deltaLength
            
            path.addLine(to: lastPoint)
            self.endPoint = lastPoint
            
            lastPoint.x += dx
            lastPoint.y += dy
            
            angle += deltaAngle
        }
        
        self.path = path
    }
}
