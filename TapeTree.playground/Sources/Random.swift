import Foundation

class Random: NSObject {
    
    class func interval(from: CGFloat, to: CGFloat) -> CGFloat {
        
        let precision: UInt32 = 10000
        return from + (to - from) * (CGFloat(arc4random_uniform(precision)) / CGFloat(precision))
    }
    
    class func value() -> CGFloat {
        return interval(from: 0.0, to: 1.0)
    }
    
    class func bool() -> Bool {
        return arc4random() % 2 == 0
    }
}
