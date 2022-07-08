//
//  AskPhotoPermissionView.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 7/5/22.
//

import UIKit
class AskPhotoPermissionView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    weak var delegate: AskPhotoPermissionViewDelegate?
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let InstaPhotoPicker access Photos to add recent photos and videos to your story."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    fileprivate lazy var enableAccessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enable photos access", for: .normal)
        let instaBlue = UIColor.rgb(red: 0, green: 152, blue: 253)
        button.setTitleColor(instaBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(didTapEnableAccessButton), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(titleLabel)
        addSubview(enableAccessButton)
        
        
        titleLabel.centerInSuperview(size: .init(width: UIScreen.main.bounds.width - 20, height: 0))
        
        
        enableAccessButton.centerXInSuperview()
        enableAccessButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        enableAccessButton.constrainHeight(constant: 50)
        enableAccessButton.constrainWidth(constant: UIScreen.main.bounds.width)
    }
    
    
    func updateTexts() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "arrow.up")?.withTintColor(.gray)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " Swipe Up to View Photos "))
        fullString.append(NSAttributedString(attachment: imageAttachment))

        titleLabel.attributedText = fullString
        enableAccessButton.isHidden = true
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapEnableAccessButton() {
        delegate?.handleAskForPhotoPermission()
    }
    
    
    
}
