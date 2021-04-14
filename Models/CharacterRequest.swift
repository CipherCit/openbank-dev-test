//
//  CharacterRequest.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import Foundation

struct CharacterRequest: Decodable {
  let code: Int?
  let status: String?
  let data: CharacterDataContainer
  
  struct CharacterDataContainer: Decodable {
    let results: [Character]?
  }
}
