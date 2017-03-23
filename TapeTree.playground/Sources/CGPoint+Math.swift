import CoreGraphics

extension CGPoint {
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (point: CGPoint, value: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * value, y: point.y * value)
    }
    
    static func lerp(from: CGPoint, to: CGPoint, time: CGFloat) -> CGPoint {
        return CGPoint(
            x: from.x + (to.x - from.x) * time,
            y: from.y + (to.y - from.y) * time
        )
    }
    
    static func angleBetween(_ a: CGPoint, and b: CGPoint) -> CGFloat {
        return atan2(b.y - a.y, b.x - a.x)
    }
    
    var magnitude: CGFloat {
        return sqrt(x * x + y * y)
    }
}
