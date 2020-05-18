import UIKit
import Vision
import Components
import Extensions

public class TrainingViewController: UIViewController {
    
    private var canvasBackground: UIView!
    private var canvasView: CanvasView!
    private var clearButton: Button!
    private var predictButton: Button!
    private var label: UILabel!
    
    var request: VNRequest {
        guard let model = try? VNCoreMLModel(for: EMNISTClassifier().model) else { fatalError("Could not load model") }
        let request = VNCoreMLRequest(model: model) { [unowned self] request, _ in
            self.handleClassification(for: request)
        }
        return request
    }



    // MARK: - Override methods


    // MARK: View did load

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purpleColor
        
        canvasBackground = UIView()
        canvasBackground.backgroundColor = .white
        canvasBackground.layer.cornerRadius = 16
        canvasBackground.layer.shadowColor = UIColor.black.cgColor
        canvasBackground.layer.shadowOffset.height = 4
        canvasBackground.layer.shadowRadius = 4
        canvasBackground.layer.shadowOpacity = 0.06
        canvasBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasBackground)
        
        canvasView = CanvasView()
        canvasView.clipsToBounds = true
        canvasView.layer.cornerRadius = 16
        canvasView.isUserInteractionEnabled = true
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasBackground.addSubview(canvasView)
        
        clearButton = Button()
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        let borderColor = UIColor(white: 1, alpha: 0.16)
        clearButton.layer.borderColor = borderColor.cgColor
        clearButton.layer.borderWidth = 1
        clearButton.layer.cornerRadius = 10
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 22, bottom: 12, right: 22)
        let font: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        clearButton.titleLabel?.font = font.makeRounded()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearCanvas), for: .touchUpInside)
        view.addSubview(clearButton)
        
        predictButton = Button()
        predictButton.setTitle("Predict", for: .normal)
        predictButton.setTitleColor(.white, for: .normal)
        predictButton.backgroundColor = .orangeColor
        predictButton.layer.cornerRadius = 10
        predictButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 22, bottom: 12, right: 22)
        predictButton.titleLabel?.font = font.makeRounded()
        predictButton.translatesAutoresizingMaskIntoConstraints = false
        predictButton.addTarget(self, action: #selector(predictWord), for: .touchUpInside)
        view.addSubview(predictButton)
        
        label = UILabel()
        label.text = "Start by writing 'A'"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold).makeRounded()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        setConstraints()
        
        setButton(false, for: predictButton, alphaWhenDisabled: 0.3)
    }
    

    // MARK: Touches moved

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let location = firstTouch.location(in: view)
        let hitView = view.hitTest(location, with: event)
        if hitView == canvasView {
            setButton(canvasView.image != nil, for: predictButton, alphaWhenDisabled: 0.3)
        }
    }



    // MARK: - Methods

        
    // MARK: Set constraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            canvasBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64),
            canvasBackground.widthAnchor.constraint(equalToConstant: 397),
            canvasBackground.heightAnchor.constraint(equalToConstant: 397),
            canvasView.leadingAnchor.constraint(equalTo: canvasBackground.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: canvasBackground.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: canvasBackground.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: canvasBackground.bottomAnchor),
            clearButton.leadingAnchor.constraint(equalTo: canvasBackground.leadingAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: canvasBackground.centerXAnchor, constant: -10),
            clearButton.topAnchor.constraint(equalTo: canvasBackground.bottomAnchor, constant: 20),
            predictButton.leadingAnchor.constraint(equalTo: canvasBackground.centerXAnchor, constant: 10),
            predictButton.trailingAnchor.constraint(equalTo: canvasBackground.trailingAnchor, constant: -20),
            predictButton.topAnchor.constraint(equalTo: canvasBackground.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: canvasBackground.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: canvasBackground.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: canvasBackground.topAnchor, constant: -24)
        ])
    }


    // MARK: Clear canvas
    
    @objc private func clearCanvas() {
        canvasView.clear()
        setButton(false, for: predictButton, alphaWhenDisabled: 0.3)
    }


    // MARK: Handle classification
    
    private func handleClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            guard let result = request.results?.first as? VNClassificationObservation else { return }
            let identifier = result.identifier
            let font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .semibold).makeRounded()
            let attributedIdentifier = NSMutableAttributedString(string: identifier, attributes: [NSAttributedString.Key.font : font])
            let attributedString = NSMutableAttributedString(string: "Last predict: ")
            attributedString.append(attributedIdentifier)
            self.label.attributedText = attributedString
        }
    }


    // MARK: Perform prediction
    
    private func performPrediction(completionHandler: (_ finished: Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = self.canvasView.image else { return }
            let startImage = CIImage(image: image)
            guard let filter = CIFilter(name: "CIColorInvert") else { return }
            filter.setValue(startImage, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { return }
            let handler = VNImageRequestHandler(ciImage: outputImage, options: [:])
            try? handler.perform([self.request])
        }
        completionHandler(true)
    }


    // MARK: Predict word
    
    @objc private func predictWord(_ sender: UIButton) {
        performPrediction { _ in
            clearCanvas()
        }
    }
}