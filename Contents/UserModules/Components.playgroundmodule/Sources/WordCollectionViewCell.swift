import UIKit
import Extensions

public class WordCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "WordCollectionViewCell.reuseIdentifier"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let letterLabel: Button = {
        let button = Button()
        button.scaleTo = 0.8
        let font: UIFont = .systemFont(ofSize: 22, weight: .semibold)
        button.titleLabel?.font = font.makeRounded()
        let titleColor = UIColor.white.withAlphaComponent(0.32)
        button.setTitleColor(titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    // MARK: Layout subviews
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        addSubview(letterLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            letterLabel.topAnchor.constraint(equalTo: topAnchor),
            letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }


    // MARK: Set current image

    public func setCurrentImage(_ currentImage: UIImage?, animated: Bool) {
        DispatchQueue.main.async {
            if animated {
                UIView.transition(with: self.imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = currentImage
                    self.letterLabel.titleLabel?.alpha = self.imageView.image == nil ? 1 : 0
                }, completion: nil)
            } else {
                self.imageView.image = currentImage
                self.letterLabel.titleLabel?.alpha = self.imageView.image == nil ? 1 : 0
            }
        }
    }
}
