//
//  MarvelRepository.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import UIKit
import Alamofire
import AlamofireImage
import CryptoKit

class MarvelRepository {
  
  private let endpoint = "https://gateway.marvel.com:443/v1/public"
  private let privateKey = "your_private_key"
  private let publicKey = "your_public_key"
  
  func getCharacters(completion: @escaping ([Character]?) -> Void) {
    if privateKey == "your_private_key" {
      fatalError("You need your own keys")
    }
    
    let url = "\(endpoint)/characters"
    
    let params = getParams()
    
    AF.request(URL(string: url)!, method: .get, parameters: params)
      .validate()
      .responseDecodable(of: CharacterRequest.self) { response in
        
      guard let characterResponse = response.value else {
        completion(nil)
        return
      }
      completion(characterResponse.data.results)
    }
  }
  
  func getCharacter(forId: Int, completion: @escaping (Character?) -> Void) {
    let url = "\(endpoint)/characters/\(forId)"
    
    let params = getParams()
    
    AF.request(URL(string: url)!, method: .get, parameters: params)
      .validate()
      .responseDecodable(of: CharacterRequest.self) { response in
        
      guard let characterResponse = response.value else {
        completion(nil)
        return
      }
      completion(characterResponse.data.results?.first)
    }
  }
  
  private func getParams() -> Parameters {
    let ts = Int.random(in: 1...10)
    let str = "\(ts)\(privateKey)\(publicKey)"
    
    let md5 = Insecure.MD5.hash(data: str.data(using: .utf8)!)
    
    let strMd5 = md5.map { String(format: "%02hhx", $0) }.joined()
    
    return [
      "apikey": publicKey,
      "hash": strMd5,
      "ts": ts
    ]
  }
}
