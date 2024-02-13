//
//  CardDetailsViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 8.12.2023.
//

import UIKit
import SDWebImage

class CardDetailsViewController: UIViewController {

  private let cardDetailsViewModel: CardDetailCellViewModel
  private var nameLabel: UILabel = UILabel()
  private var artistLabel: UILabel = UILabel()
  private var imageView: UIImageView = UIImageView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    layoutSubviews()
    
    let font = UIFont(name:"Marker Felt", size: 20)
    self.artistLabel.text = "Artist Name: \(cardDetailsViewModel.artist)"
    self.artistLabel.font = font
    self.nameLabel.text = "Pokemon Name: \(cardDetailsViewModel.name)"
    self.nameLabel.font = font
    self.imageView.sd_setImage(with: URL(string: cardDetailsViewModel.imageUrlHiRes), completed: nil)
  }

  init(card: CardDetailCellViewModel) {
    self.cardDetailsViewModel = card
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func layoutSubviews() {
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
      imageView.widthAnchor.constraint(equalToConstant: 300),
      imageView.heightAnchor.constraint(equalToConstant: 400)
    ])

    view.addSubview(artistLabel)
    artistLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      artistLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
    ])

    view.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),   nameLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20)
    ])
  }
}

