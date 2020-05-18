import UIKit

public extension UIFont {
    
    // MARK: Get SF Pro Rounded
    
    func makeRounded() -> UIFont {
        return UIFont(descriptor: fontDescriptor.withDesign(.rounded) ?? fontDescriptor, size: pointSize)
    }
}
