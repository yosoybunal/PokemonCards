//
//  SearchResultsModel.swift
//  PokemonCards
//
//  Created by Berkay Unal on 7.12.2023.
//

import Foundation

struct SearchResultsModel: Codable {

  let cards: [Card]
}

struct Card: Codable {

  let id: String
  let name: String
  let imageUrl: String
  let imageUrlHiRes: String
  let artist: String
  let hp: String
}

