//
//  SeachViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class SeachViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

  var searchController: UISearchController!

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    initiliazeSearchResultsStoryboard()
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Enter a hp up to 3 digits."
  }

  // MARK: - Update Search Results
  func updateSearchResults(for searchController: UISearchController) {

    guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
          let query = searchController.searchBar.text,
          !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }


    APICaller.shared.searchWithHP(with: query) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let results):
          resultsController.update(with: results)
        case .failure(let error):
          let alert = UIAlertController(title: "Wrong Format!", message: "Please enter a hp value up to 3 digits.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in 
            searchController.searchBar.text = ""
          }))
          self?.present(alert, animated: true)
          print(error)
          break
        }
      }
    }
    print(query)
  }

  // MARK: - Initiliaze Storyboard

  private func initiliazeSearchResultsStoryboard() {

    let searchResultsStoryboard = UIStoryboard(name: "SearchResults", bundle: nil)
    guard let onboardingViewController = searchResultsStoryboard.instantiateInitialViewController() as? SearchResultsViewController else {
      fatalError("Unable to Instantiate Onboarding View Controller")
    }
    searchController = UISearchController(searchResultsController: onboardingViewController)
  }
}

