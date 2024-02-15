//
//  NotificationView.swift
//  PokemonCards
//
//  Created by Berkay Unal on 15.02.2024.
//

import UIKit

final class NotificationView: UIView {

  let notificationView = UIView()
  let notificationLabel = UILabel()

  func configureNotificationView(view: UIView) {
    notificationLabel.textAlignment = .center
    notificationLabel.textColor = .systemBackground
    notificationLabel.translatesAutoresizingMaskIntoConstraints = false
    notificationLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    notificationView.addSubview(notificationLabel)

    NSLayoutConstraint.activate([
      notificationLabel.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
      notificationLabel.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor)
    ])
    notificationView.backgroundColor = .secondaryLabel
    notificationView.frame = CGRect(x: 5, y: view.frame.height - 125, width: view.frame.width - 10, height: 40)
    notificationView.layer.cornerRadius = 15
    notificationView.isHidden = true
    view.addSubview(notificationView)
  }

  func showNotification(message: String, view: UIView) {
    notificationLabel.text = message
    notificationView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.notificationView.frame.origin.y = view.frame.height - 125
    }) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.hideNotification(view: view)
      }
    }
  }

  func hideNotification(view: UIView) {
    UIView.animate(withDuration: 0.3) {
      self.notificationView.frame.origin.y = view.frame.height
    } completion: { _ in
      self.notificationView.isHidden = true
    }
  }
}
