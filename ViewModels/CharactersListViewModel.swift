//
//  CharactersListViewModel.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import UIKit

class CharactersListViewModel {
  
  private let repository = MarvelRepository()
  
  private(set) var characters: [Character]? {
    didSet {
      charactersDidUpdate?(characters)
    }
  }
  
  var charactersDidUpdate: (([Character]?) -> Void)?
  
  func fetchCharacters() {
    repository.getCharacters() { [weak self] characters in
      self?.characters = characters
    }
  }
}
