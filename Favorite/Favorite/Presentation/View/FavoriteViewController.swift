//
//  FavoriteViewController.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 19/11/24.
//

import Combine
import Common
import UIKit

public class FavoriteViewController: UIViewController {
    
    let tableView = UITableView()
    
    private var cancellables = Set<AnyCancellable>()
    private var favorites: [FavoriteEntity] = []
    private var favoriteId: Int = 0
    
    var emptyLabel = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        setupNavigationBar()
        setupTableView()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        getFavoritesV2()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .backgroundColor
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self /// IMPORTANT | to register cells for tableView
        tableView.delegate = self /// IMPORTANT
    }
    
    func getFavoritesV2() {
        let usecase = Injection.init().provideUseCase()
        let presenter = FavoritePresenter(useCase: usecase)
        
        presenter.getFavorites()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    self.handleEmptyState()
                }
            }, receiveValue: { value in
                self.favorites = value
                self.handleEmptyState()
                self.tableView.reloadData()
            })
            .store(in: &self.cancellables)
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "GRText", in: Bundle(identifier: "com.nafladiva.Common"), compatibleWith: .current)!
        ]
        appearance.titleTextAttributes = titleTextAttributes
        appearance.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .primaryColor
        navigationItem.title = "Favorites"
    }
    
    func handleEmptyState() {
        if favorites.isEmpty {
            emptyLabel.text = "Favorite list is empty"
            emptyLabel.textColor = .textColor
            tableView.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
        } else {
            emptyLabel.removeFromSuperview()
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favorite = favorites[indexPath.row]
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        tableCell.backgroundColor = .backgroundColor
        tableCell.selectionStyle = .none
        
        DispatchQueue.main.async {
            tableCell.cellImageView.image = UIImage(data: favorite.image!)
            tableCell.nameLabel.text = favorite.name
            tableCell.releasedLabel.text = DateUtil.formatReleaseDate(responseDate: favorite.released!, fromFormat: "yyyy-MM-dd", toFormat: "MMM d, yyyy")
            tableCell.genreLabel.text = favorite.genres
            tableCell.ratingLabel.text = "★ \(favorite.rating!)"
        }
       
        return tableCell
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    public func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
        //TODO: import DetailScreen
//        let detailViewController = DetailViewController()
//        detailViewController.gameId = Int(favorites[indexPath.row].id ?? 0)
//        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
