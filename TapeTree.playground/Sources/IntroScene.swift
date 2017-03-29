import SpriteKit

class IntroScene : SKScene, ContinueButtonDelegate {
    
    let background = SKSpriteNode(imageNamed: "intro")
    let button = ContinueButton()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(background)
        
        button.position = CGPoint(x: size.width * 0.5, y: 65.0)
        button.delegate = self
        addChild(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func continueButtonWasPressed(continueButton: ContinueButton) {
        
        let game = GameScene(size: self.size)
        view?.presentScene(game, transition: .fade(withDuration: 2.0))
    }
}
