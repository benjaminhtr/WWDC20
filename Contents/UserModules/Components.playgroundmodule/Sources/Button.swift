import UIKit

public class Button: UIButton {
    
    public var scaleTo: CGFloat = 0.92
    

    // MARK: Layout subviews
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        addTarget(self, action: #selector(holdingDown), for: .touchDown)
        addTarget(self, action: #selector(holdingDown), for: .touchDownRepeat)
        addTarget(self, action: #selector(holdingDown), for: .touchDragEnter)
        addTarget(self, action: #selector(holdingDown), for: .touchDragInside)
        addTarget(self, action: #selector(holdingUp), for: .touchUpInside)
        addTarget(self, action: #selector(holdingUp), for: .touchUpOutside)
        addTarget(self, action: #selector(holdingUp), for: .touchDragExit)
        addTarget(self, action: #selector(holdingUp), for: .touchCancel)
        addTarget(self, action: #selector(holdingUp), for: .touchDragOutside)
        
        adjustsImageWhenHighlighted = false
    }
    


    // MARK: Button animations
    
    
    // usingSpringWithDamping and initialSpringVelocity to make it smooooooth
    
    @objc private func holdingDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform(scaleX: self.scaleTo, y: self.scaleTo)
        }, completion: nil)
    }
    
    @objc private func holdingUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
