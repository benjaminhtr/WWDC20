import UIKit

public class CanvasView: UIImageView {
    

    // MARK: Touches moved
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: bounds)
        var touches = [UITouch]()
        
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        
        touches.forEach { touch in
            drawStroke(context: context, touch: touch)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    

    // MARK: Draw stroke
    
    private func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        UIColor.black.setStroke()
        
        guard let context = context else { return }
        context.setLineCap(.round)
        context.setLineWidth(20)
        
        context.move(to: previousLocation)
        context.addLine(to: location)
        
        context.strokePath()
    }
    
    
    // MARK: Clear canvas
    
    public func clear(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.alpha = 1
                self.image = nil
            })
        } else {
            image = nil
        }
    }
}
