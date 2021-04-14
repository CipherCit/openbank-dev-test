//
//  CharactersListCell.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import UIKit

class CharactersListCell: UICollectionViewCell {
  
  static let reuseIdentifier = "charactersListCell"
  
  private lazy var characterName: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .title3)
    lbl.adjustsFontForContentSizeCategory = true
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.backgroundColor = .clear
    lbl.textColor = .systemBackground
    return lbl
  }()
  
  private lazy var characterDescription: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.backgroundColor = .clear
    lbl.textColor = .systemBackground
    lbl.numberOfLines = 0
    return lbl
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not happening")
  }
  
  private func setupViews() {
    backgroundColor = .systemGreen
    layer.cornerRadius = 15
    
    addSubview(characterName)
    addSubview(characterDescription)
    
    NSLayoutConstraint.activate([
      characterName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      characterName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      characterName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      characterName.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
      
      characterDescription.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 10),
      characterDescription.leadingAnchor.constraint(equalTo: characterName.leadingAnchor),
      characterDescription.trailingAnchor.constraint(equalTo: characterName.trailingAnchor),
      characterDescription.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
    ])
    
  }
  
  func config(forCharacter character: Character) {
    characterName.text = character.name ?? "Unknown character"
    characterDescription.text = character.description ?? ""
  }
}
