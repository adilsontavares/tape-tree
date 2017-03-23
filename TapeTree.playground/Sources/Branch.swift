import SpriteKit

enum BranchType {
    case left
    case right
    case center
    case unknown
}

class Branch : SKShapeNode {
    
    var parentBranch: Branch?
    var type: BranchType = .unknown
    
    var accent: Branch?
    var branches = [Branch]()
    
    var depth: Int = 0 {
        didSet {
            updateLineWidth()
        }
    }
    
    private(set) var to: CGPoint
    var color: SKColor = SKColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0) {
        didSet {
            strokeColor = color
        }
    }
    
    var animationTime: CGFloat = 1.0 {
        didSet {
            updatePath()
        }
    }
    
    init(to: CGPoint) {
        
        self.to = to
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        updatePath()
        updateLineWidth()
        
        strokeColor = color
    }
    
    private func updatePath() {
        
        let path = CGMutablePath()
        
        if type == .center {
            
            let middle = to * 0.5
            
            path.move(to: CGPoint.lerp(from: middle, to: .zero, time: animationTime))
            path.addLine(to: CGPoint.lerp(from: middle, to: to, time: animationTime))
        }
        else {
            path.move(to: .zero)
            path.addLine(to: CGPoint.lerp(from: .zero, to: to, time: animationTime))
        }
        
        self.path = path
    }
    
    private func updateLineWidth() {
        lineWidth = (1.0 - CGFloat(depth) / CGFloat(Config.maxDepth)) * 6.0 + 1.0
    }
    
    func createSubBranches() -> [Branch] {
        
        for branch in branches {
            branch.removeFromParent()
        }
        
        if let branch = self.accent {
            branch.removeFromParent()
        }
        
        let colorVariation: CGFloat = 0.05
        let hue: CGFloat = modf(self.color.hueComponent + colorVariation).1
        let color = SKColor(hue: hue, saturation: 0.9, brightness: 1.0, alpha: 1.0)
        
        let accent = Branch.from(center: to, angle: CGPoint.angleBetween(.zero, and: to) + CGFloat.pi * 0.5, length: to.magnitude / 3.0)
        accent.color = .orange
        accent.parentBranch = self
        accent.depth = self.depth + 1
        accent.type = .center
        self.addChild(accent)
        
        let firstTime = Random.interval(from: 0.25, to: 0.75)
        let times = [
            firstTime,
            Random.interval(from: max(0.5, firstTime), to: 1.0)
        ]
        
        let first = Branch.from(CGPoint.lerp(from: .zero, to: to, time: times[0]), passingBy: accent.position)
        first.type = .left
        first.parentBranch = self
        first.depth = self.depth + 1
        first.color = color
        self.addChild(first)
        
        let second = Branch.from(CGPoint.lerp(from: .zero, to: to, time: times[1]), passingBy: accent.position + accent.to)
        second.parentBranch = self
        second.type = .right
        second.depth = self.depth + 1
        second.color = color
        self.addChild(second)
        
        self.accent = accent
        self.branches = [first, second]
        
        return self.branches
    }
    
    // MARK: Create trees
    
    class func createTree(withDepth depth: Int, color: SKColor) -> Branch {
        
        let offset  = CGPoint(x: Random.interval(from: -70.0, to: 70.0), y: Random.interval(from: 120.0, to: 170.0))
        let root = Branch.from(CGPoint(x: 0.0, y: 0.0), to: offset)
        
        root.color = color
        
        func createSubBranches(nodes: [Branch]) {
            for node in nodes {
                if node.depth >= Config.maxDepth {
                    continue
                }
                createSubBranches(nodes: node.createSubBranches())
            }
        }
        
        var nodes = [Branch]()
        
        nodes.append(contentsOf: root.createSubBranches())
        
        while let node = nodes.first {
            
            if node.depth < Config.maxDepth {
                nodes.append(contentsOf: node.createSubBranches())
            }
            
            nodes.removeFirst()
        }
        
        return root
    }
    
    // MARK: Create branches
    
    class func from(_ from: CGPoint, passingBy point: CGPoint) -> Branch {
        
        let angle = CGPoint.angleBetween(from, and: point)
        let magnitude = (point - from).magnitude * 2.0
        let branch = Branch.from(from, to: from + CGPoint(x: cos(angle) * magnitude, y: sin(angle) * magnitude))
        
        return branch
    }
    
    class func from(center: CGPoint, angle: CGFloat, length: CGFloat) -> Branch {
        
        let dx = cos(angle) * length * 0.5
        let dy = sin(angle) * length * 0.5
        
        let from = center + CGPoint(x:  dx, y:  dy)
        let to   = center + CGPoint(x: -dx, y: -dy)
        
        return Branch.from(from, to: to)
    }
    
    class func from(_ from: CGPoint, to: CGPoint) -> Branch {
        
        let branch = Branch(to: CGPoint(x: to.x - from.x, y: to.y - from.y))
        branch.position = from
        
        return branch
    }
    
    func setTreeAnimationTime(_ time: CGFloat) {
            
        self.animationTime = time
        self.accent?.animationTime = time
        
        for branch in branches {
            branch.setTreeAnimationTime(time)
        }
    }
    
    func calculateDepth() -> Int {
        
        if branches.isEmpty {
            return self.depth
        }
        
        var depth = branches.first?.depth ?? 0
        
        for branch in branches {
            
            let cur = branch.calculateDepth()
            
            if cur > depth {
                depth = cur
            }
        }
        
        return depth
    }
    
    func grow(withDuration duration: TimeInterval) {
        
        self.alpha = 1.0
        
        setTreeAnimationTime(0.0)
        
        let totalDepth = self.calculateDepth()
        let deltaDuration = (duration / TimeInterval(totalDepth)) * 0.5
        
        let updateAnim = SKAction.customAction(withDuration: deltaDuration) { node, time in
            
            let ratio = time / CGFloat(deltaDuration)
            self.animationTime = ratio
        }
        
        let centerAnim = SKAction.customAction(withDuration: deltaDuration) { (node, time) in
            
            let ratio = time / CGFloat(deltaDuration)
            self.accent?.animationTime = ratio
        }
        
        let nextAnim = SKAction.run {
            for branch in self.branches {
                branch.grow(withDuration: duration - deltaDuration)
            }
        }
        
        let actions = SKAction.sequence([
            updateAnim,
            centerAnim,
            nextAnim
        ])
        
        self.run(actions)
    }
    
    func decrease(withDuration duration: TimeInterval) {
        
        setTreeAnimationTime(1.0)
        
        let totalDepth = self.calculateDepth()
        let deltaDuration = (duration / TimeInterval(totalDepth)) * 0.5
        
        for branch in self.branches {
            branch.decrease(withDuration: duration - deltaDuration)
        }
        
        let updateAnim = SKAction.customAction(withDuration: deltaDuration) { node, time in
            
            let ratio = 1 - (time / CGFloat(deltaDuration))
            self.animationTime = ratio
            self.alpha = 1 - ratio
        }
        
        let centerAnim = SKAction.customAction(withDuration: deltaDuration) { (node, time) in
            
            let ratio = time / CGFloat(deltaDuration)
            self.accent?.animationTime = 1 - ratio
        }
        
        let wait = SKAction.wait(forDuration: TimeInterval(totalDepth) * deltaDuration)
        
        let actions = SKAction.sequence([
            wait,
            centerAnim,
            updateAnim,
        ])
        
        self.run(actions)
    }
}
