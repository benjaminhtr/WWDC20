import UIKit

public class DirectionButton: Button {
    
    public enum Direction {
        case left
        case right
    }
    
    private var direction: Direction
    
    
    // MARK: Initialization
    
    public required init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Layout subviews
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setAppearance(direction)
    }
    
    
    // MARK: Set appearance
    
    private func setAppearance(_ direction: Direction) {
        switch direction {
        case .left:
            let leftImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysTemplate)
            setImage(leftImage, for: .normal)
        default:
            let rightImage = UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate)
            setImage(rightImage, for: .normal)
        }
        
        tintColor = .orangeColor
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset.height = 4
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.06
        layer.cornerRadius = 16
    }
}
