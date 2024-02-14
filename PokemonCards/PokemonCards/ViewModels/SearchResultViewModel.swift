//
//  SearchResultViewModel.swift
//  PokemonCards
//
//  Created by Berkay Unal on 14.02.2024.
//

import UIKit

final class SearchResultViewModel {

  func fetchData(for searchController: UISearchController, with query: String) {

    guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
          let query = searchController.searchBar.text,
          !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

    APICaller.shared.searchWithHP(with: query) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let results):
          let cards = results.compactMap({
            SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
          })
          resultsController.getSearchResults(cards: cards)

          let cardDetails = results.compactMap({
            CardDetailCellViewModel(name: $0.name, artist: $0.artist, imageUrlHiRes: $0.imageUrlHiRes)
          })
          resultsController.getCardDetails(cards: cardDetails)
          
        case .failure(let error):
          print(error)
          break
        }
      }
    }
  }
}
