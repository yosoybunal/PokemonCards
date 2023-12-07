//
//  APICaller.swift
//  PokemonCards
//
//  Created by Berkay Unal on 7.12.2023.
//

import Foundation

final class APICaller {

  static let shared = APICaller()
  private init(){}

  struct Constants {

    static let APIURL = "https://api.pokemontcg.io/v1/cards?hp=gte99"
  }

  // MARK: - Search API

  public func search(completionHandler: @escaping (Result<SearchResultsModel, Error>) -> Void) {

    guard let url = URL(string: Constants.APIURL) else { return }

    URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
      guard let data = data, error == nil else { return }

      do{
        let result = try 
//        JSONSerialization.jsonObject(with: data)
        JSONDecoder().decode(SearchResultsModel.self, from: data)
        completionHandler(.success(result))
      } catch(let error) {
        print(error.localizedDescription)
        completionHandler(.failure(error))
      }
    } .resume()
  }
}
