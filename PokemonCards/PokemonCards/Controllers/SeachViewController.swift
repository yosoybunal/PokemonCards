//
//  SeachViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class SeachViewController: UIViewController, UISearchResultsUpdating {
  
  var searchController: UISearchController!

// MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    initiliazeSearchResultsStoryboard()
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    
  }

// MARK: - Update Search Results

  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }

//    let vc = searchController.searchResultsController as? SearchResultsViewController
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

