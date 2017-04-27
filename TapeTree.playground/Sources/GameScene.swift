import SpriteKit
import AVFoundation

class GameScene : SKScene {
    
    var rootBranch: Branch!
    var swing: TreeSwing!
    var butterfly: Butterfly!
    var slideshow: Slideshow!
    var musicPlayer: AVPlayer!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        musicPlayer = AVPlayer(url: Bundle.main.url(forResource: "music", withExtension: "m4a")!)
        musicPlayer.play()
        
        swing = TreeSwing(length: size.height * 0.95, nodeCount: 10, width: 100)
        swing.position = CGPoint(x: 150, y: size.height)
        swing.zPosition = 10
        swing.startAnimation(withDuration: 6.0, rotation: CGFloat.pi * 0.1)
        addChild(swing)
        
        butterfly = Butterfly(size: 20.0)
        butterfly.position = CGPoint(x: size.width + butterfly.size, y: size.height * 0.8)
        swing.seat.addChild(butterfly)
        
        slideshow = Slideshow(content: [
            "The flapping of a butterfly's wings",
            "...can change the future.",
            "And you...",
            "...what are you doing to change the world?"
        ])
        slideshow.label.fontSize = 21.0
        slideshow.zPosition = 100.0
        slideshow.position = CGPoint(x: 15, y: 15)
        slideshow.label.horizontalAlignmentMode = .left
        slideshow.label.verticalAlignmentMode = .bottom
        addChild(slideshow)
        
        animateBackground()
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
            self.animateButterfly()
            
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { _ in
                self.slideshow.animate()
            })
            
            Timer.scheduledTimer(withTimeInterval: 13, repeats: false, block: { _ in
                self.animateTree(growDuration: 8.0, liveDuration: 6.0, decreaseDuration: 2.5)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateTree(growDuration: TimeInterval, liveDuration: TimeInterval, decreaseDuration: TimeInterval) {
        
        self.createRoot()
        self.rootBranch.grow(withDuration: growDuration)
        self.animateBranches(from: self.rootBranch)
        
        Timer.scheduledTimer(withTimeInterval: growDuration + liveDuration, repeats: false, block: { _ in
            self.rootBranch.decrease(withDuration: decreaseDuration)
        })
        
        Timer.scheduledTimer(withTimeInterval: growDuration + liveDuration + decreaseDuration, repeats: false) { _ in
            self.animateTree(growDuration: 6.0, liveDuration: 3.0, decreaseDuration: 2.0)
        }
    }
    
    private func animateBackground() {
        
        let backgroundOffset: CGFloat = Random.interval01()
        let backgroundDuration: TimeInterval = 50.0
        let backgroundAction = SKAction.customAction(withDuration: backgroundDuration, actionBlock: { (node, time) in
            (node as! SKScene).backgroundColor = SKColor(
                hue: modf(backgroundOffset + time / CGFloat(backgroundDuration)).1,
                saturation: 0.4,
                brightness: 0.21,
                alpha: 1.0
            )
        })
        run(SKAction.repeatForever(backgroundAction))
    }
    
    private func animateBranches(from branch: Branch) {
        
        for b in branch.branches {
            animateBranches(from: b)
        }
        
        let minTime: CGFloat = 0.3
        let maxTime: CGFloat = 1.5
        
        let max: CGFloat = 0.03 * CGFloat.pi
        
        let actions = [
            SKAction.rotate(byAngle: Random.interval(from: -0.2, to: 0.2) * max, duration: TimeInterval(Random.interval(from: minTime, to: maxTime))),
            SKAction.rotate(byAngle: Random.interval(from: -0.2, to: 0.2) * max, duration: TimeInterval(Random.interval(from: minTime, to: maxTime))),
            SKAction.rotate(byAngle: Random.interval(from: -0.2, to: 0.2) * max, duration: TimeInterval(Random.interval(from: minTime, to: maxTime))),
            SKAction.rotate(toAngle: 0.0, duration: TimeInterval(Random.interval(from: minTime, to: maxTime)))
        ]
        
        for action in actions {
            action.timingMode = .easeInEaseOut
        }
        
        let action = SKAction.sequence(actions)
        branch.run(SKAction.repeatForever(action))
    }
    
    private func animateButterfly() {
        
        var actions = [SKAction]()
        
        let startAction = SKAction.move(to: CGPoint(x: 0.0, y: 40.0), duration: 2.0)
        
        self.butterfly.stopAnimation()
        self.butterfly.animate(withDuration: 0.13)
        
        actions.append(SKAction.wait(forDuration: 1.0))
        actions.append(startAction)
        
        for _ in 0 ..< 3 {
            
            let x = Random.interval(from: -100.0, to: size.width + 100.0)
            let y = Random.interval(from: 0, to: size.height + 100.0)
            
            let action = SKAction.move(to: CGPoint(x: x, y: y), duration: TimeInterval(Random.interval01() * 2.0 + 2.0))
            action.timingMode = .easeInEaseOut
            
            actions.append(action)
        }
        
        actions.append(startAction)
        actions.append(SKAction.move(to: .zero, duration: TimeInterval(Random.interval01() * 2.0 + 1.0)))
        
        actions.append(SKAction.wait(forDuration: 2.0))
        actions.append(SKAction.run {
            
            self.butterfly.stopAnimation()
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Random.interval(from: 7.0, to: 12.0)), repeats: false, block: { _ in
                self.animateButterfly()
            })
        })
        
        butterfly.run(SKAction.sequence(actions))
    }
    
    private func createRoot() {
        
        if let branch = rootBranch {
            branch.removeFromParent()
        }
        
        rootBranch = Branch.createTree(
            withDepth: Config.maxDepth,
            color: SKColor(
                hue: modf(backgroundColor.hueComponent + 0.5).1,
                saturation: Random.interval(from: 0.5, to: 1.0),
                brightness: Random.interval(from: 0.5, to: 1.0),
                alpha: 1.0
            )
        )
        rootBranch.position = CGPoint(x: size.width * 0.7, y: 20.0)
        addChild(rootBranch)
    }
}
