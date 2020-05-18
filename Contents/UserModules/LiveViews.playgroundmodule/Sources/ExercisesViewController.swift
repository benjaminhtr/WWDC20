import UIKit
import Vision
import Extensions
import Components
import AVFoundation

public class ExercisesViewController: UIViewController {
    
    private var navigationView: NavigationView!
    private var mainContainer: UIView!
    
    private var currentLetterIndicator: UIView!
    private var currentLetterIndicatorInset: NSLayoutConstraint!
    private var wordFlowLayout: UICollectionViewFlowLayout!
    private var wordCollectionView: UICollectionView!
    private var wordCollectionViewWidth: NSLayoutConstraint!
    
    private var canvasFlowLayout: CarouselFlowLayout!
    private var canvasCollectionView: UICollectionView!
    
    private var leftButton: DirectionButton!
    private var leftButtonInset: NSLayoutConstraint!
    
    private var rightButton: DirectionButton!
    private var rightButtonInset: NSLayoutConstraint!
    
    private var pageControl: UIPageControl!
    
    private var pointsBackground: UIView!
    private var pointsLabel: UILabel!
    
    
    private var points = 0 {
        didSet {
            pointsLabel.text = "\(points) Points"
        }
    }
    
    private var allWords: [String]!
    
    private var currentWord = "Umbrella" {
        didSet {
            wordCollectionViewWidth.constant = CGFloat(currentWord.count * 48)
            navigationView.title = "Write \(currentWord)"
            pageControl.numberOfPages = currentWord.count
            wordCollectionView.reloadData()
            canvasCollectionView.reloadData()
        }
    }
    
    private var images = [Int: UIImage]() {
        didSet {
            setCanvasImagePreview(for: wordCollectionView, images: images)
        }
    }
    
    private var currentIndex: CGFloat = 0 {
        didSet {
            pageControl.currentPage = Int(currentIndex + 0.5)
            currentLetterIndicatorInset.constant = 48 * currentIndex
            setButton(!(currentIndex <= 0.5), for: leftButton, alphaWhenDisabled: 0)
            setButton(!(currentIndex >= CGFloat(currentWord.count) - 1.5), for: rightButton, alphaWhenDisabled: 0)
        }
    }
    
    private let similarCharacters = ["4": "U", "1": "I", "6": "G", "M": "N", "0": "O", "Q": "O", "8": "S"]
    private var characterArray = [String]()
    
    private var request: VNRequest {
        guard let model = try? VNCoreMLModel(for: EMNISTClassifier().model) else { fatalError("Could not load model") }
        let request = VNCoreMLRequest(model: model) { [unowned self] request, _ in
            self.handleClassification(for: request)
        }
        return request
    }

    private var audioPlayer: AVAudioPlayer!
    
    
    
    // MARK: - Override methods
    
    
    // MARK: View did load
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .light
        view.backgroundColor = .secondarySystemBackground
        allWords = load("words.json")
        
        navigationView = NavigationView(with: "Write \(currentWord)")
        navigationView.refreshButton.addTarget(self, action: #selector(newWord), for: .touchUpInside)
        navigationView.clearButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        navigationView.predictButton.addTarget(self, action: #selector(predictTapped), for: .touchUpInside)
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        mainContainer = UIView()
        mainContainer.backgroundColor = .purpleColor
        mainContainer.clipsToBounds = true
        mainContainer.layer.cornerRadius = 20
        mainContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainContainer)
        
        currentLetterIndicator = UIView()
        currentLetterIndicator.backgroundColor = UIColor(white: 1, alpha: 0.1)
        currentLetterIndicator.clipsToBounds = true
        currentLetterIndicator.layer.cornerRadius = 10
        currentLetterIndicator.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(currentLetterIndicator)
        
        wordFlowLayout = UICollectionViewFlowLayout()
        wordFlowLayout.itemSize = CGSize(width: 48, height: 48)
        wordFlowLayout.minimumLineSpacing = 0
        wordFlowLayout.scrollDirection = .horizontal
        
        wordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: wordFlowLayout)
        wordCollectionView.register(
            WordCollectionViewCell.self,
            forCellWithReuseIdentifier: WordCollectionViewCell.reuseIdentifier
        )
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        wordCollectionView.backgroundColor = .clear
        wordCollectionView.delaysContentTouches = false
        wordCollectionView.isScrollEnabled = false
        wordCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(wordCollectionView)
        
        canvasFlowLayout = CarouselFlowLayout()
        canvasFlowLayout.itemSize = CGSize(width: 397, height: 397)
        canvasFlowLayout.scrollDirection = .horizontal
        
        canvasCollectionView = UICollectionView(frame: .zero, collectionViewLayout: canvasFlowLayout)
        canvasCollectionView.register(
            CanvasCollectionViewCell.self,
            forCellWithReuseIdentifier: CanvasCollectionViewCell.reuseIdentifier
        )
        canvasCollectionView.delegate = self
        canvasCollectionView.dataSource = self
        canvasCollectionView.isScrollEnabled = false
        canvasCollectionView.backgroundColor = .clear
        canvasCollectionView.showsHorizontalScrollIndicator = false
        canvasCollectionView.clipsToBounds = true
        canvasCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(canvasCollectionView)
        
        leftButton = DirectionButton(direction: .left)
        leftButton.addTarget(self, action: #selector(scrollLeft), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(leftButton)
        
        rightButton = DirectionButton(direction: .right)
        rightButton.addTarget(self, action: #selector(scrollRight), for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(rightButton)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = currentWord.count
        pageControl.currentPage = Int(currentIndex)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(pageControl)
        
        pointsBackground = UIView()
        pointsBackground.layer.cornerRadius = 15
        pointsBackground.backgroundColor = UIColor(white: 1, alpha: 0.2)
        pointsBackground.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(pointsBackground)
        
        pointsLabel = UILabel()
        pointsLabel.text = "0 Points"
        pointsLabel.textColor = .white
        let pointsFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        pointsLabel.font = pointsFont.makeRounded()
        pointsLabel.textAlignment = .center
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(pointsLabel)
        
        setConstraints()
        setButton(!(currentIndex <= 0.5), for: leftButton, alphaWhenDisabled: 0)

        guard let path = Bundle.main.path(forResource: "success.mp3", ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
    }
    
    
    // MARK: View will layout subviews
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        leftButtonInset.constant = max(-(223.5 + (view.bounds.width - 511) / 4), -384.17)
        rightButtonInset.constant = min(223.5 + (view.bounds.width - 511) / 4, 384.17)
    }
    
    
    
    // MARK: - Methods
    
    
    // MARK: Set constraints
    
    private func setConstraints() {
        currentLetterIndicatorInset = currentLetterIndicator.leadingAnchor.constraint(equalTo: wordCollectionView.leadingAnchor)
        wordCollectionViewWidth = wordCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(currentWord.count * 48))
        
        let leftConstant = max(-(223.5 + (view.bounds.width - 511) / 4), -384.17)
        let rightConstant = min(223.5 + (view.bounds.width - 511) / 4, 384.17)
        leftButtonInset = leftButton.trailingAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: leftConstant)
        rightButtonInset = rightButton.leadingAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: rightConstant)
        
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 90),
            
            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            wordCollectionView.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            wordCollectionView.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 40),
            wordCollectionViewWidth,
            wordCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            currentLetterIndicatorInset,
            currentLetterIndicator.topAnchor.constraint(equalTo: wordCollectionView.topAnchor),
            currentLetterIndicator.bottomAnchor.constraint(equalTo: wordCollectionView.bottomAnchor),
            currentLetterIndicator.widthAnchor.constraint(equalToConstant: 48),
            
            canvasCollectionView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            canvasCollectionView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            canvasCollectionView.topAnchor.constraint(equalTo: wordCollectionView.bottomAnchor, constant: 18),
            canvasCollectionView.heightAnchor.constraint(equalToConstant: 397),
            
            leftButtonInset,
            leftButton.centerYAnchor.constraint(equalTo: canvasCollectionView.centerYAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 32),
            leftButton.heightAnchor.constraint(equalToConstant: 32),
            
            rightButtonInset,
            rightButton.centerYAnchor.constraint(equalTo: canvasCollectionView.centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 32),
            rightButton.heightAnchor.constraint(equalToConstant: 32),
            
            pageControl.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: canvasCollectionView.bottomAnchor, constant: 12),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            pointsLabel.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            pointsLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 38),
            
            pointsBackground.topAnchor.constraint(equalTo: pointsLabel.topAnchor, constant: -6),
            pointsBackground.bottomAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 6),
            pointsBackground.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -16),
            pointsBackground.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor, constant: 16)
        ])
    }
    
    
    // MARK: load file from main bundle
    
    private func load<T: Decodable>(_ filename: String) -> T {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        guard let data = try? Data(contentsOf: file) else {
            fatalError("Could not load \(filename) from main bundle.")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Could not parse \(filename).")
        }
    }


    // MARK: Show alert

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Got it!", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: New random word
    
    @objc private func newWord() {
        clearAll()
        guard let newWord = allWords.randomElement() else { return }
        guard newWord != currentWord else { return }
        currentWord = newWord
    }
    
    
    // MARK: Clear canvas
    
    @objc private func clearCanvas(_ sender: UIButton) {
        let point: CGPoint = sender.convert(.zero, to: canvasCollectionView)
        guard let indexPath = canvasCollectionView.indexPathForItem(at: point) else { return }
        guard let cell = canvasCollectionView.cellForItem(at: indexPath) as? CanvasCollectionViewCell else { return }
        cell.canvasView.clear()
        images.removeValue(forKey: indexPath.row)
        guard let wordCell = wordCollectionView.cellForItem(at: indexPath) as? WordCollectionViewCell else { return }
        wordCell.setCurrentImage(nil, animated: true)
        setButton(images.count == currentWord.count, for: navigationView.predictButton, alphaWhenDisabled: 0.3)
    }
    
    
    // MARK: Clear all
    
    @objc private func clearAll() {
        images.removeAll()
        wordCollectionView.reloadData()
        canvasCollectionView.reloadData()
        canvasCollectionView.contentOffset.x = 0
    }
    
    
    // MARK: Scroll to specific item
    
    @objc private func scrollToItem(_ sender: UIButton) {
        let point: CGPoint = sender.convert(.zero, to: wordCollectionView)
        guard let indexPath = wordCollectionView.indexPathForItem(at: point) else { return }
        canvasCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    // MARK: Scroll left
    
    @objc private func scrollLeft(_ sender: UIButton) {
        let newIndex = Int(currentIndex) - 1
        canvasCollectionView.scrollToItem(at: IndexPath(row: newIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    // MARK: Scroll right
    
    @objc private func scrollRight(_ sender: UIButton) {
        let newIndex = Int(currentIndex) + 1
        canvasCollectionView.scrollToItem(at: IndexPath(row: newIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    // MARK: Set canvas image preview
    
    func setCanvasImagePreview(for collectionView: UICollectionView, images: [Int: UIImage]) {
        guard collectionView == wordCollectionView else { return }
        
        for (index, _) in currentWord.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? WordCollectionViewCell else { return }
            
            if images.index(forKey: index) != nil {
                guard let image = images[index] else { return }
                let startImage = CIImage(image: image)
                guard let filter = CIFilter(name: "CIColorInvert") else { return }
                filter.setValue(startImage, forKey: kCIInputImageKey)
                guard let outputImage = filter.outputImage else { return }
                let newImage = UIImage(ciImage: outputImage)
                cell.setCurrentImage(newImage, animated: true)
            } else {
                cell.setCurrentImage(nil, animated: false)
            }
        }
        
        setButton(images.count == currentWord.count, for: navigationView.predictButton, alphaWhenDisabled: 0.3)
    }
    
    
    // MARK: Handle classification
    
    private func handleClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            guard let result = request.results?.first as? VNClassificationObservation else { return }
            self.characterArray = self.characterArray.map { $0.capitalized }
            let identifier = result.identifier.capitalized
            
            if self.characterArray.contains(identifier) {
                guard let index = self.characterArray.firstIndex(of: identifier) else { return }
                self.characterArray.remove(at: index)
            } else if let similarIdentifier = self.similarCharacters[identifier], self.characterArray.contains(similarIdentifier) {
                guard let index = self.characterArray.firstIndex(of: similarIdentifier) else { return }
                self.characterArray.remove(at: index)
            }

            if self.characterArray.isEmpty {
                self.points += 5
                self.audioPlayer.play()

                if [25, 50, 100].contains(self.points) {
                    self.showAlert(title: "Congrats!", message: "You reached \(self.points) points! Thank you for playing. 🎉🚀")
                }
            }
        }
    }
    
    
    // MARK: Perform prediction
    
    private func performPrediction() {
        DispatchQueue.global(qos: .userInitiated).async {
            let inputImages = self.images.map ({ return $0.value })
            inputImages.forEach { inputImage in
                let startImage = CIImage(image: inputImage.withBackground(color: .white))
                guard let filter = CIFilter(name: "CIColorInvert") else { return }
                filter.setValue(startImage, forKey: kCIInputImageKey)
                guard let outputImage = filter.outputImage else { return }
                let handler = VNImageRequestHandler(ciImage: outputImage, options: [:])
                try? handler.perform([self.request])
            }
        }
    }
    
    
    // MARK: Predict tapped
    
    @objc private func predictTapped(_ sender: UIButton) {
        characterArray = currentWord.map { String($0).capitalized }
        performPrediction()
        DispatchQueue.main.async {
            self.newWord()
            setButton(false, for: sender, alphaWhenDisabled: 0.3)
        }
    }
}



// MARK: - UICollectionViewDataSource

extension ExercisesViewController: UICollectionViewDataSource {
    
    
    // MARK: Number of items in section
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentWord.count
    }
    
    
    // MARK: Cell for item at
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == wordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.reuseIdentifier, for: indexPath) as! WordCollectionViewCell
            let word = Array(currentWord)
            cell.letterLabel.setTitle(String(word[indexPath.row]), for: .normal)
            cell.letterLabel.addTarget(self, action: #selector(scrollToItem), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasCollectionViewCell.reuseIdentifier, for: indexPath) as! CanvasCollectionViewCell
            cell.clearButton.addTarget(self, action: #selector(clearCanvas), for: .touchUpInside)
            cell.canvasView.image = images[indexPath.row]
            return cell
        }
    }
}



// MARK: - UICollectionViewDelegate

extension ExercisesViewController: UICollectionViewDelegate {
    
    
    // MARK: Did select item
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == canvasCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CanvasCollectionViewCell else { return }
            guard let image = cell.canvasView.image else { return }
            images[indexPath.row] = image
        }
    }
}



// MARK: - UICollectionViewDelegate

extension ExercisesViewController: UIScrollViewDelegate {
    
    
    // MARK: Scroll view did scroll
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == canvasCollectionView {
            currentIndex = scrollView.contentOffset.x / 400
        }
    }
}