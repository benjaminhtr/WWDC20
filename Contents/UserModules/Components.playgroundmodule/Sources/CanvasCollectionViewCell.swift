import UIKit

public class CanvasCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "CanvasCollectionViewCell.reuseIdentifier"
    
    public let canvasView: CanvasView = {
        let canvasView = CanvasView()
        canvasView.isUserInteractionEnabled = true
        canvasView.clipsToBounds = true
        canvasView.layer.cornerRadius = 16
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()
    
    public let clearButton: Button = {
        let button = Button()
        button.scaleTo = 0.8
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Layout subviews
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(canvasView)
        contentView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            canvasView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: contentView.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            clearButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            clearButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset.height = 4
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.06
    }
    
}
