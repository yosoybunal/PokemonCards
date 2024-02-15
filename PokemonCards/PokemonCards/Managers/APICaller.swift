//
//  APICaller.swift
//  PokemonCards
//
//  Created by Berkay Unal on 7.12.2023.
//

import Foundation

enum NetworkError: Error {
  case urlError
  case canNotParseData
}

final class APICaller {

  static let shared = APICaller()
  private init(){}

  struct Constants {

    static let baseURL = "https://api.pokemontcg.io/v1/cards?hp=gte"
  }

  // MARK: - Search API

  public func searchWithHP(with query: String, completionHandler: @escaping (Result<[Card], Error>) -> Void) {

    guard let url = URL(string: Constants.baseURL+"\(query)") else { return }

    URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
      guard error == nil else {
        completionHandler(.failure(NetworkError.urlError))
        return
      }
      guard let data = data else { return }
      do{
        let result = try
        JSONDecoder().decode(SearchResultsModel.self, from: data)
        completionHandler(.success(result.cards))
      } catch {
        completionHandler(.failure(NetworkError.canNotParseData))
      }
    } .resume()
  }
}
