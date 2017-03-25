import SpriteKit

class TreeSwingSeat : SKShapeNode {
    
    var distortion: CGFloat
    var width: CGFloat
    var depth: CGFloat
    
    init(width: CGFloat, depth: CGFloat, distortion: CGFloat) {
        
        self.width = width
        self.depth = depth
        self.distortion = distortion
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        lineWidth = 2
        strokeColor = .white
        fillColor = .lightGray
        
        updatePath()
    }
    
    private func updatePath() {
        
        let points = [
            CGPoint(x: -width * 0.5 + distortion, y: depth * 0.5),
            CGPoint(x: width * 0.5 + distortion, y: depth * 0.5),
            CGPoint(x: width * 0.5 - distortion, y: -depth * 0.5),
            CGPoint(x: -width * 0.5 - distortion, y: -depth * 0.5)
        ]
        
        let path = CGMutablePath()
        path.move(to: points.first!)
        
        for i in 1 ..< points.count {
            path.addLine(to: points[i])
        }
        
        path.closeSubpath()
        self.path = path
    }
}
