import CoreGraphics

extension CGFloat {
    
    func lerp(to: CGFloat, time: CGFloat) -> CGFloat {
        return CGFloat.lerp(from: self, to: to, time: time)
    }
    
    static func lerp(from: CGFloat, to: CGFloat, time: CGFloat) -> CGFloat {
        return from + (to - from) * time
    }
}
