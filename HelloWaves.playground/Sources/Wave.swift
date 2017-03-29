import SpriteKit

class Wave : SKShapeNode {
    
    private(set) var length: CGFloat
    private(set) var nodes = [WaveNode]()
    private(set) var nodeRadius: CGFloat {
        didSet {
            for node in nodes {
                node.radius = nodeRadius
            }
        }
    }
    
    var fixLastNode = false
    
    init(length: CGFloat, nodeCount: Int) {
        
        self.nodeRadius = 2.0
        self.length = length
        
        super.init()
        
        createNodes(nodeCount)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createNodes(_ count: Int) {
        
        for _ in 0 ..< count {
            
            let node = createNode(at: .zero)
            nodes.append(node)
            
            self.addChild(node)
        }
        
        reset()
    }
    
    private func setup() {
        
        lineWidth = 3.0
        strokeColor = .blue
        fillColor = .clear
        
        updatePath()
    }
    
    private func createNode(at position: CGPoint) -> WaveNode {
        
        let node = WaveNode(radius: nodeRadius)
        node.position = position
        
        return node
    }
    
    private func updatePath() {
        
        let path = CGMutablePath()
        
        if !nodes.isEmpty {
            path.move(to: nodes[0].position)
        }
        
        for node in nodes where node != nodes.first {
            path.addLine(to: node.position)
        }
        
        self.path = path
    }
    
    private func updatePhysics() {
        
        for i in 0 ..< nodes.count {
            
            let node = nodes[i]
            let left: WaveNode? = (i != 0) ? nodes[i - 1] : nil
            let right: WaveNode? = (i != nodes.count - 1) ? nodes[i + 1] : nil
            
            node.updatePhysics(left: left, right: right)
        }
        
        for node in nodes {
            node.updateDestination()
            node.update(withTime: 1.0)
        }
    }
    
    func reset() {
        
        let dx = length / CGFloat(nodes.count - 1)
        
        for i in 0 ..< nodes.count {
            
            let node = nodes[i]
            let point = CGPoint(x: dx * CGFloat(i), y: 0.0)
            
            node.position = point
            node.reset()
        }
    }
    
    func update() {
        
        if fixLastNode {
            if let lastNode = nodes.last {
                lastNode.position = CGPoint(x: lastNode.position.x, y: 0.0)
            }
        }
        
        updatePhysics()
        updatePath()
    }
}
