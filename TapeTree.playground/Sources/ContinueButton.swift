import SpriteKit

protocol ContinueButtonDelegate {
    func continueButtonWasPressed(continueButton: ContinueButton)
}

class ContinueButton : SKSpriteNode {
    
    var delegate: ContinueButtonDelegate?
    
    init() {
        
        let texture = SKTexture(imageNamed: "continue")
        super.init(texture: texture, color: .white, size: texture.size())
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.continueButtonWasPressed(continueButton: self)
    }
}
