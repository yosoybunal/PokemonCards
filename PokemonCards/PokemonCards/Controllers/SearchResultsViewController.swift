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

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate {

  @IBOutlet var collectionView: UICollectionView!
  private var searchViewModels = [SearchResultCellViewModel]()
  private var detailViewModels = [CardDetailsCellViewModel]()
  weak var delegate: ResultDelegate?

  // MARK: - VC Lifecycle

  override func viewDidLoad() {

    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    collectionView.reloadData()
  }

  // MARK: - Initiliaze Storyboard

//  private func initiliazeSearchResultsStoryboard() {
//
//    let searchResultsStoryboard = UIStoryboard(name: "CardDetails", bundle: nil)
//    guard let searchResultsVC = searchResultsStoryboard.instantiateInitialViewController() as? CardDetailsViewController else {
//      fatalError("Unable to Instantiate Onboarding View Controller")
//    }
//  }

  //  private func registerCells() {
  //    collectionView.register(UINib(nibName: SearchResultsCollectionViewCell.identifier, bundle: nil),
  //                                     forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
  //  }

  // MARK: - Delegate

  func itemTapped(with items: [Card]) {

    detailViewModels = items.compactMap({
      CardDetailsCellViewModel(name: $0.name, artist: $0.artist, imageUrlHiRes: $0.imageUrlHiRes)
    })
//    collectionView.reloadData()
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


