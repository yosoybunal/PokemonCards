//
//  SearchResultViewModel.swift
//  PokemonCards
//
//  Created by Berkay Unal on 14.02.2024.
//

import UIKit

protocol SearchResultViewModelDelegate: AnyObject {
  func getSearchResults(cards: [SearchResultCellViewModel])
  func getCardDetails(cards: [CardDetailCellViewModel])
}

final class SearchResultViewModel {

  weak var delegate: SearchResultViewModelDelegate?

  func fetchData(with query: String) {

    APICaller.shared.searchWithHP(with: query) { [weak self] result in
        switch result {
        case .success(let results):
          let cards = results.compactMap({
            SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
          })
          self?.delegate?.getSearchResults(cards: cards)
          let cardDetails = results.compactMap({
            CardDetailCellViewModel(name: $0.name, artist: $0.artist, imageUrlHiRes: $0.imageUrlHiRes)
          })
          self?.delegate?.getCardDetails(cards: cardDetails)
        case .failure(let error):
          print(error)
          break
        }

    }
  }
}
