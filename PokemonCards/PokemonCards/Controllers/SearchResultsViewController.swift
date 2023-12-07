//
//  SearchResultsViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, CollectionViewItemDelegate {

  @IBOutlet var collectionView: UICollectionView!
  private var viewModels = [SearchResultCellViewModel]()

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    collectionView.reloadData()
  }

  //  private func registerCells() {
  //    collectionView.register(UINib(nibName: SearchResultsCollectionViewCell.identifier, bundle: nil),
  //                                     forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
  //  }

  // MARK: - Delegate

  func itemTapped(cell: SearchResultsCollectionViewCell) {

  }

  func update(with results: [Card]) {
    viewModels = results.compactMap({
                  SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl )
                })
    collectionView.reloadData()
    collectionView.isHidden = results.isEmpty
  }
}

// MARK: - DataSource

extension SearchResultsViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath)
            as? SearchResultsCollectionViewCell else { return UICollectionViewCell()}
    cell.configure(viewModel: viewModels[indexPath.row])
    return cell
  }
}
