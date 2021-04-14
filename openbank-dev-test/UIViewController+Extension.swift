//
//  UIViewController+Extension.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 14/4/21.
//

import UIKit

extension UIViewController {
  func showSpinner() {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.tag = 100
    spinner.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(spinner)
    
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    spinner.startAnimating()
  }
  
  func hideSpinner() {
    if let spinner = view.viewWithTag(100) as? UIActivityIndicatorView {
      spinner.stopAnimating()
      spinner.removeFromSuperview()
    }
  }
}
