//
//  SearchResultsCollectionViewCell.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit
import SDWebImage

class SearchResultsCollectionViewCell: UICollectionViewCell {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var textLabel: UILabel!

  private var viewModel: SearchResultCellViewModel?
  static let identifier = "cell"

// MARK: - Configure Cell

  func configure(viewModel: SearchResultCellViewModel) {
    self.viewModel = viewModel

    let transformer = SDImageResizingTransformer(size: CGSize(width: 150, height: 180), scaleMode: .fill)
    imageView.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
    textLabel.text = viewModel.name

    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    addGestureRecognizer(longPressGesture)
  }
}

//MARK: - Gesture Recognizer

extension SearchResultsCollectionViewCell {

  @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {

    switch gestureRecognizer.state {
    case .ended:

      var retrievedItems: [SearchResultCellViewModel] = []

      let defaultItems = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites") ?? []
      retrievedItems.append(contentsOf: defaultItems)

      if let item = viewModel {
        retrievedItems.append(item)
      }

      print("viewModel saved!")
      UserDefaults.standard.save(customObject: retrievedItems, inKey: "Favorites")

    default: break
    }
  }
}
