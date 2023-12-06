//
//  SeachViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class SearchResultsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemMint
  }

}

class SeachViewController: UIViewController, UISearchResultsUpdating {

  let searchController = UISearchController(searchResultsController: SearchResultsViewController())

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGreen
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    
//    let vc = searchController.searchResultsController as? SearchResultsViewController
  }
}

