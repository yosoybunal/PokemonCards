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

    static let healthBaseURL = "https://api.pokemontcg.io/v1/cards?hp=gte"
  }

  // MARK: - Search API

  public func searchWithHP(with query: String, completionHandler: @escaping (Result<[Card], Error>) -> Void) {

    guard let url = URL(string: Constants.healthBaseURL+"\(query)") else { return }

    URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
      guard let data = data, error == nil else { return }
      do{
        let result = try
        //        JSONSerialization.jsonObject(with: data)
        JSONDecoder().decode(SearchResultsModel.self, from: data)
        completionHandler(.success(result.cards))
      } catch(let error) {
        completionHandler(.failure(error))
      }
    } .resume()
  }
}
