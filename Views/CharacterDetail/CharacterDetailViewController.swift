//
//  CharacterDetailViewController.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 14/4/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
  
  private lazy var nameLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .title3)
    lbl.adjustsFontForContentSizeCategory = true
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    return lbl
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .body)
    lbl.adjustsFontForContentSizeCategory = true
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private lazy var characterImage: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .systemGray
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.isHidden = true
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()
  
  private lazy var closeImage: UIImageView = {
    let iv = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.tintColor = .systemGray
    iv.isUserInteractionEnabled = true
    return iv
  }()
  
  private var viewModel: CharacterDetailViewModel!
  private var spinner = UIActivityIndicatorView(style: .large)
  
  init(withViewModel: CharacterDetailViewModel) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = withViewModel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupViews()
    
    viewModel.characterDidUpdate = { [weak self] character in
      guard let self = self else { return }
        
      self.hideSpinner()
      
      if let char = character {
        self.nameLabel.text = char.name
        self.descriptionLabel.text = char.description
        self.characterImage.isHidden = false
        
        if let thumbnail = char.thumbnail {
          self.characterImage.load(url: URL(string: "\(thumbnail.path).\(thumbnail.ext)")!)
        }
        
      } else {
        self.nameLabel.isHidden = true
        self.characterImage.isHidden = true
        self.descriptionLabel.text = "There was an error retriving the character information. Try again later"
        self.descriptionLabel.textColor = .systemGray
      }
    }
    
    showSpinner()
    viewModel.fetchCharacter()
    
    closeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    characterImage.layer.cornerRadius = characterImage.frame.height / 2
  }
  
  private func setupViews() {
    view.addSubview(nameLabel)
    view.addSubview(characterImage)
    view.addSubview(descriptionLabel)
    view.addSubview(closeImage)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      nameLabel.heightAnchor.constraint(equalToConstant: 30),
      
      characterImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
      characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      characterImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor),
      
      descriptionLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
      descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      closeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
      closeImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
      closeImage.heightAnchor.constraint(equalToConstant: 30),
      closeImage.widthAnchor.constraint(equalTo: closeImage.heightAnchor)
    ])
  }
  
  @objc private func closeAction(recognizer: UITapGestureRecognizer) {
    dismiss(animated: true)
  }
}
