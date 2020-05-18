import UIKit


// MARK: Set button enabled

public func setButton(_ enabled: Bool, for button: UIButton, alphaWhenDisabled: CGFloat) {
    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        button.alpha = enabled ? 1 : alphaWhenDisabled
        button.isUserInteractionEnabled = enabled
    }, completion: nil)
}
