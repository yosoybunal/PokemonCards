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
  static let identifier = "SearchResultsCollectionViewCell"

  func configure(viewModel: SearchResultCellViewModel) {
    self.viewModel = viewModel
    let transformer = SDImageResizingTransformer(size: CGSize(width: 150, height: 180), scaleMode: .fill)
    imageView.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
    textLabel.text = viewModel.name
  }
}


