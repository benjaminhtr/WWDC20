import UIKit
import Extensions

public class IntroductionViewController: UIViewController {
    
    private var centerImageView: UIImageView!
    private var leftImageView: UIImageView!
    private var rightImageView: UIImageView!
    private var welcomeLabel: UILabel!


    // MARK: View did load

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        centerImageView = UIImageView()
        centerImageView.image = UIImage(named: "memoji-1")
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerImageView)
        
        leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "memoji-2")
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftImageView)
        
        rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "memoji-3")
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightImageView)
        
        welcomeLabel = UILabel()
        welcomeLabel.text = "EMNIST Writing"
        let welcomeFont: UIFont = .systemFont(ofSize: 46, weight: .bold)
        welcomeLabel.font = welcomeFont.makeRounded()
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        setConstraints()
    }


    // MARK: Set constraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            centerImageView.widthAnchor.constraint(equalToConstant: 440),
            centerImageView.heightAnchor.constraint(equalToConstant: 440),
            leftImageView.trailingAnchor.constraint(equalTo: centerImageView.leadingAnchor, constant: 54),
            leftImageView.centerYAnchor.constraint(equalTo: centerImageView.centerYAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 250),
            leftImageView.heightAnchor.constraint(equalToConstant: 250),
            rightImageView.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: -54),
            rightImageView.centerYAnchor.constraint(equalTo: centerImageView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 250),
            rightImageView.heightAnchor.constraint(equalToConstant: 250),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerImageView.bottomAnchor)
        ])
    }
}
