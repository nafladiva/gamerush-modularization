//
//  TableViewLoader.swift
//  Common
//
//  Created by Nafla Diva Syafia on 30/11/24.
//

import UIKit

public extension UITableView {
     func showLoading() {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .grText
            let activityView = activityIndicator
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
