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
    APICaller.shared.search() { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let model):
          self?.viewModels = model.cards.compactMap({
            SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl )
          })
          self?.collectionView.reloadData()
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }

//  private func registerCells() {
//    collectionView.register(UINib(nibName: SearchResultsCollectionViewCell.identifier, bundle: nil),
//                                     forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
//  }

// MARK: - Delegate

  func itemTapped(cell: SearchResultsCollectionViewCell) {

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
