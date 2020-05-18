import UIKit
import Extensions

public class NavigationView: UIView {
    
    public var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let font: UIFont = .systemFont(ofSize: 22, weight: .semibold)
        label.font = font.makeRounded()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let refreshButton: Button = {
        let button = Button()
        button.scaleTo = 0.8
        let image = UIImage(named: "repeat")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        let tintColor = UIColor.label.withAlphaComponent(0.65)
        button.tintColor = tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let clearButton: Button = {
        let button = Button()
        button.setTitle("Clear all", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        let borderColor = UIColor(white: 0, alpha: 0.1)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 22, bottom: 12, right: 22)
        let font: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        button.titleLabel?.font = font.makeRounded()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let predictButton: Button = {
        let button = Button()
        button.setTitle("Predict word", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let backgroundColor = UIColor(red: 246/255, green: 105/255, blue: 101/255, alpha: 1)
        button.backgroundColor = backgroundColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 22, bottom: 12, right: 22)
        let font: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        button.titleLabel?.font = font.makeRounded()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    // MARK: Init
    
    public required init(with title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Layout subviews
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setAppearance()
    }
    
    
    // MARK: Set appearance
    
    private func setAppearance() {
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(refreshButton)
        addSubview(clearButton)
        addSubview(predictButton)
        
        setButton(false, for: predictButton, alphaWhenDisabled: 0.3)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 36),
            refreshButton.heightAnchor.constraint(equalToConstant: 36),
            refreshButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            refreshButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            clearButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            predictButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            predictButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
