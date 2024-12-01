//
//  ViewController.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 11/11/24.
//

import Combine
import Common
import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    private var cancellables = Set<AnyCancellable>()
    private var games: [GameEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        setupNavigationBar()
        setupTableView()
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "gameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if games.isEmpty {
            getGames()
        }
    }
    
    func getGames() {
        let usecase = Injection.init().provideUseCase()
        let presenter = GamePresenter(useCase: usecase)
        
        tableView.showLoading()
        presenter.getGamesV2()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.showErrorAlert(message: "Unexpected error: \(error.localizedDescription)")
                    self.tableView.hideLoading()
                }
            }, receiveValue: { value in
                self.games = value
                self.tableView.hideLoading()
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
        navigationItem.title = "🎮 GameRush"
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
    
    func showErrorAlert(message: String?) {
        let alert = UIAlertController(
            title: "Error",
            message: message ?? "Something's wrong!\nPlease check your connection and retry.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.getGames()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        tableCell.backgroundColor = .backgroundColor
        tableCell.selectionStyle = .none
        
        var genres = ""
        for genre in game.genres {
            if genres.isEmpty {
                genres += genre.name
            } else {
                genres += " • \(genre.name)"
            }
        }
        
        DispatchQueue.main.async {
            tableCell.cellImageView.image = game.backgroundImage
            tableCell.nameLabel.text = game.name
            tableCell.releasedLabel.text = DateUtil.formatReleaseDate(responseDate: game.released, fromFormat: "yyyy-MM-dd", toFormat: "MMM d, yyyy")
            tableCell.genreLabel.text = genres
            tableCell.ratingLabel.text = "★ \(game.rating)"
        }
       
        return tableCell
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
        let detailViewController = DetailViewController()
        detailViewController.gameId = games[indexPath.row].id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
