//
//  Character.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import Foundation

struct Character: Decodable, Hashable {
  let id: Int?
  let name: String?
  let description: String?
  let thumbnail: CharacterThumbnail?
  
  struct CharacterThumbnail: Decodable, Hashable {
    let path: String
    let ext: String
    
    private enum CodingKeys: String, CodingKey {
      case path
      case ext = "extension"
    }
  }
}
