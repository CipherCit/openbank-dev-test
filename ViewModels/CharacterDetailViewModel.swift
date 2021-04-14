//
//  CharacterDetailViewModel.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 14/4/21.
//

import UIKit

class CharacterDetailViewModel {
  private let repository = MarvelRepository()
  
  private(set) var character: Character? {
    didSet {
      characterDidUpdate?(character)
    }
  }
  
  var characterDidUpdate: ((Character?) -> Void)?
  
  private var characterId: Int!
  
  init(withCharacterId id: Int) {
    self.characterId = id
  }
  
  func fetchCharacter() {
    repository.getCharacter(forId: characterId) { [weak self] character in
      self?.character = character
    }
  }
}
