//
//  StoriesEditorVC.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit
class StoriesEditorVC: UIViewController {
    
    
    //MARK: - Init
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setUpViews()
        bindData()
        setUpGestureRecognizer()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //so when we can use zoomview animation to exit this controller
        navigationController?.delegate = zoomNavigationDelegate
    }
    
    
    //MARK: - Properties
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    fileprivate let zoomNavigationDelegate = ZoomTransitionDelegate()
    fileprivate let selectedImage: UIImage
    fileprivate let buttonDimen: CGFloat = 45
    
    fileprivate lazy var textButton = createTopButton(imageName: "textformat", targetAction: #selector(didTapButtonBeyondScopeOfTutorial))
    fileprivate lazy var stickerButton = createTopButton(imageName: "moon.stars", targetAction: #selector(didTapButtonBeyondScopeOfTutorial))
    fileprivate lazy var filtersButton = createTopButton(imageName: "sparkles", targetAction: #selector(didTapButtonBeyondScopeOfTutorial))
    fileprivate lazy var optionsButton = createTopButton(imageName: "ellipsis", targetAction: #selector(didTapButtonBeyondScopeOfTutorial))
    fileprivate lazy var backButton = createTopButton(imageName: "chevron.left", targetAction: #selector(didTapBackButton))
    fileprivate lazy var uploadButton = createTopButton(imageName: "arrow.right", targetAction: #selector(didTapButtonBeyondScopeOfTutorial),
                                                      backgroundColor: .white, tintColor: .black, imageWeight: .heavy)
    
    
    fileprivate lazy var shareToYourStoryButton = createBottomButton(imageName: "person.circle.fill", title: "Your story")

    fileprivate lazy var shareToCloseFriendsButton = createBottomButton(imageName: "star.circle.fill", title: "Close Friends")
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        // imageView layout
        view.addSubview(imageView)
        imageView.fillSuperview()
        
        let stackViewSpacing: CGFloat = 5
        var stackViewWidth: CGFloat = buttonDimen * 4
        stackViewWidth += stackViewSpacing * 4
        let stackViewVerticalpading: CGFloat = buttonDimen - 10

        let stackView = UIStackView(arrangedSubviews: [textButton, stickerButton, filtersButton, optionsButton])
        stackView.axis = .horizontal
        stackView.spacing = stackViewSpacing
        stackView.distribution = .equalCentering
        
        // stackView layout
        imageView.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -stackViewVerticalpading, left: 0, bottom: 0, right: 10), size: .init(width: stackViewWidth, height: buttonDimen))
        
        // backButton layout
        imageView.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        backButton.constrainToLeft(paddingLeft: 10)
        
        // uploadButton layout
        imageView.addSubview(uploadButton)
        uploadButton.centerXAnchor.constraint(equalTo: optionsButton.centerXAnchor).isActive = true
        uploadButton.constrainToBottom(paddingBottom: -10)
        
        // shareToCloseFriendsButton layout
        imageView.addSubview(shareToCloseFriendsButton)
        shareToCloseFriendsButton.trailingAnchor.constraint(equalTo: uploadButton.leadingAnchor, constant: -8).isActive = true
        shareToCloseFriendsButton.centerYAnchor.constraint(equalTo: uploadButton.centerYAnchor).isActive = true
        shareToCloseFriendsButton.constrainHeight(constant: buttonDimen)
        shareToCloseFriendsButton.constrainWidth(constant: 150)
        
        // shareToYourStoryButton layout
        imageView.addSubview(shareToYourStoryButton)
        shareToYourStoryButton.trailingAnchor.constraint(equalTo: shareToCloseFriendsButton.leadingAnchor, constant: -8).isActive = true
        shareToYourStoryButton.centerYAnchor.constraint(equalTo: shareToCloseFriendsButton.centerYAnchor).isActive = true
        shareToYourStoryButton.constrainHeight(constant: buttonDimen)
        shareToYourStoryButton.constrainWidth(constant: 120)
        
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    
    fileprivate func setUpGestureRecognizer() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapBackButton))
        swipeDownGesture.direction = .down
        imageView.addGestureRecognizer(swipeDownGesture)
    }
    
    
    
    fileprivate func bindData() {
        imageView.image = selectedImage
        getDominantColor(from: selectedImage)
    }
    
    
    
    /// Gets dominant color from image and sets the cell's background color to the retrieved color
   fileprivate func getDominantColor(from image: UIImage) {
        do {
            try imageView.backgroundColor = selectedImage.averageColor()
            try view.backgroundColor = selectedImage.averageColor()

        } catch let error {
            print("failed to set background color ", error.localizedDescription)
        }
    }
    
    
    
    
    fileprivate func createTopButton(imageName: String, targetAction: Selector, backgroundColor: UIColor = UIColor.rgb(red: 39, green: 39, blue: 39), tintColor: UIColor = .white, imageWeight: UIImage.SymbolWeight = .semibold) -> UIButton {
        let button = UIButton(type: .system)
        button.constrainHeight(constant: buttonDimen)
        button.constrainWidth(constant: buttonDimen)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = buttonDimen / 2
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: imageWeight, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)

        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.addTarget(self, action: targetAction, for: .touchUpInside)
        return button
    }
    
    
    fileprivate func createBottomButton(imageName: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .medium)
        let image = UIImage(systemName: imageName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)

        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.tintColor = .green
        button.backgroundColor = UIColor.rgb(red: 39, green: 39, blue: 39)
        button.layer.cornerRadius = buttonDimen / 2
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapButtonBeyondScopeOfTutorial), for: .touchUpInside)
        return button
    }
    
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}



//MARK: - ZoomViewController For Transition animation
extension StoriesEditorVC: ZoomViewController {
    
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        return imageView
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nil
    }
    
    
}
