//
//  SearchResultsViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

protocol ResultDelegate: AnyObject {

  func didTapCell(item: CardDetailsCellViewModel)
}

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var longPressText: UILabel!

  private var searchViewModels = [SearchResultCellViewModel]()
  private var detailViewModels = [CardDetailsCellViewModel]()
  weak var delegate: ResultDelegate?
  var searchController: UISearchController!

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    initiliazeSearchResultsStoryboard()
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Enter a HP up to 3 digits."
    view.backgroundColor = .systemBackground
  }

    private func initiliazeSearchResultsStoryboard() {
      let searchResultsStoryboard = UIStoryboard(name: "SearchResults", bundle: nil)
      guard let searchResultsVC = searchResultsStoryboard.instantiateInitialViewController() as? SearchResultsViewController else {
        fatalError("Unable to Instantiate Onboarding View Controller")
      }
      searchResultsVC.delegate = self
      self.searchController = UISearchController(searchResultsController: searchResultsVC)
    }


  // MARK: - Delegate

  func itemTapped(with items: [Card]) {

    detailViewModels = items.compactMap({
      CardDetailsCellViewModel(name: $0.name, artist: $0.artist, imageUrlHiRes: $0.imageUrlHiRes)
    })
  }

  func update(with results: [Card]) {

    searchViewModels = results.compactMap({
      SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
    })
    collectionView.reloadData()
    collectionView.isHidden = results.isEmpty
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    collectionView.deselectItem(at: indexPath, animated: true)
    let card = detailViewModels[indexPath.row]
    delegate?.didTapCell(item: card)
  }

  func updateSearchResults(for searchController: UISearchController) {

    guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
          let query = searchController.searchBar.text,
          !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

    APICaller.shared.searchWithHP(with: query) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let results):
          resultsController.update(with: results)
          resultsController.itemTapped(with: results)
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
  }
}

// MARK: - DataSource

extension SearchResultsViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return searchViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath)
            as? SearchResultsCollectionViewCell else { return UICollectionViewCell()}
    cell.configure(viewModel: searchViewModels[indexPath.row])
    return cell
  }
}

extension SearchResultsViewController: ResultDelegate {
  func didTapCell(item: CardDetailsCellViewModel) {
    let vc = CardDetailsViewController(card: item)
    navigationController?.pushViewController(vc, animated: true)
  }
}
