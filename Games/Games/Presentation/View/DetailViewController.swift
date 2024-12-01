//
//  DetailViewController.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 14/11/24.
//

import Combine
import Common
import UIKit

public class DetailViewController: UIViewController {
    
    public var gameId: Int?
    var gameDetail: GameDetailEntity? = nil
    var isFavorite: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let gameImageView = UIImageView()
    let nameLabel = UILabel()
    let genreValueLabel = UILabel()
    let releasedValueLabel = UILabel()
    let ratingValueLabel = UILabel()
    let descTitle = UILabel()
    let descValueLabel = UILabel()
    let developerTitle = UILabel()
    let developerLabel = UILabel()
    let publisherTitle = UILabel()
    let publisherLabel = UILabel()
    var favoriteButtonBar = UIBarButtonItem()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        setupScrollView()
        buildUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGameDetail()
        getFavoriteStatus()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = view.frame.size
    }
    
    func getFavoriteStatus() {
        let usecase = Injection.init().provideUseCase()
        let presenter = GamePresenter(useCase: usecase)
        
        presenter.checkFavoriteStatus(gameId: gameId ?? 0)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    self.isFavorite = false
                }
            }, receiveValue: { value in
                self.isFavorite = value
                self.updateFavoriteBarStatus()
            })
            .store(in: &self.cancellables)
    }
    
    func getGameDetail() {
        let usecase = Injection.init().provideUseCase()
        let presenter = GamePresenter(useCase: usecase)
        
        showLoading()
        presenter.getGameDetail(gameId: gameId ?? 0)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.showErrorAlert(message: "Unexpected error: \(error.localizedDescription)")
                    self.hideLoading()
                }
            }, receiveValue: { value in
                self.gameDetail = value
                self.hideLoading()
                self.initData()
            })
            .store(in: &self.cancellables)
    }
    
    func addFavorite() {
        let usecase = Injection.init().provideUseCase()
        let presenter = GamePresenter(useCase: usecase)
        
        var genres = ""
        for genre in gameDetail?.genres ?? [] {
            if genres.isEmpty {
                genres += genre.name
            } else {
                genres += " • \(genre.name)"
            }
        }
        
        if let image = gameDetail?.backgroundImage, let data = image.pngData() as NSData? {
            presenter.addFavorite(
                gameDetail?.id ?? 0,
                gameDetail?.name ?? "",
                data as Data,
                genres,
                gameDetail?.released ?? "",
                gameDetail?.rating ?? 0
            )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Error while adding favorite", preferredStyle: .alert)
                            
                        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }, receiveValue: { _ in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Added", message: "Game added to Favorite", preferredStyle: .alert)
                        
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .store(in: &self.cancellables)
        }
    }
    
    func removeFavorite() {
        let usecase = Injection.init().provideUseCase()
        let presenter = GamePresenter(useCase: usecase)
        
        presenter.removeFavorite(gameId: gameId ?? 0)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Error while removing favorite", preferredStyle: .alert)
                            
                        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }, receiveValue: { _ in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Removed", message: "Game removed from Favorite", preferredStyle: .alert)
                        
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .store(in: &self.cancellables)
    }
    
    /// Reference: https://stackoverflow.com/a/27227174
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .primaryColor
        let websiteButtonBar = UIBarButtonItem(title: "Web", image: UIImage(systemName: "globe"), target: self, action: #selector(goToWebsite))
        favoriteButtonBar = UIBarButtonItem(title: "Favorite", image: UIImage(systemName: isFavorite ? "heart" : "heart.fill"), target: self, action: #selector(handleFavorite))
        navigationItem.rightBarButtonItems = [websiteButtonBar, favoriteButtonBar]
    }
    
    @objc func goToWebsite() {
        if let url = URL(string: gameDetail?.website ?? ""), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        }
    }
    
    @objc func handleFavorite() {
        var genres = ""
        for genre in gameDetail?.genres ?? [] {
            if genres.isEmpty {
                genres += genre.name
            } else {
                genres += " • \(genre.name)"
            }
        }
        
        if self.isFavorite {
            self.addFavorite()
        } else {
            self.removeFavorite()
        }
        
        self.updateFavoriteBarStatus()
    }
    
    func updateFavoriteBarStatus() {
        favoriteButtonBar.image = UIImage(systemName: isFavorite ? "heart" : "heart.fill")
    }
    
    func buildUI() {
        setupGameImage()
        setupNameLabel()
        setupGenreLabel()
        setupReleasedLabel()
        setupRatingLabel()
        setupDescLabel()
        setupDeveloperLabel()
        setupPublisherLabel()
    }
    
    func initData() {
        setupNavigationBar()
        
        gameImageView.image = gameDetail?.backgroundImage
        
        // set image ratio
        let imageMultiplier = (gameImageView.image?.size.width ?? 0) / (gameImageView.image?.size.height ?? 0)
        gameImageView.widthAnchor.constraint(equalTo: gameImageView.heightAnchor, multiplier: imageMultiplier).isActive = true
        
        nameLabel.text = gameDetail?.name
        
        var genres = ""
        for genre in gameDetail?.genres ?? [] {
            if genres.isEmpty {
                genres += genre.name
            } else {
                genres += " • \(genre.name)"
            }
        }
        genreValueLabel.text = genres
        releasedValueLabel.text = DateUtil.formatReleaseDate(responseDate: gameDetail?.released ?? "", fromFormat: "yyyy-MM-dd", toFormat: "MMM d, yyyy")
        ratingValueLabel.text = "★ \(gameDetail?.rating ?? 0) / 5"
        
        descTitle.text = "Description"
        descValueLabel.text = gameDetail?.descriptionRaw
        
        var developers = ""
        for developer in gameDetail?.developers ?? [] {
            developers += "• \(developer.name)\n"
        }
        developerTitle.text = "Developers"
        developerLabel.text = developers
        
        var publishers = ""
        for publisher in gameDetail?.publishers ?? [] {
            publishers += "• \(publisher.name) (\(publisher.gamesCount) published games)\n"
        }
        publisherTitle.text = "Publishers"
        publisherLabel.text = publishers
    }
    
    func setupGameImage() {
        contentView.addSubview(gameImageView)
        gameImageView.contentMode = .scaleAspectFit
        gameImageView.layer.masksToBounds = true
        gameImageView.clipsToBounds = true
        gameImageView.backgroundColor = .textColor
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8.0),
            gameImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            gameImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        nameLabel.textColor = .textColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 16.0),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupGenreLabel() {
        contentView.addSubview(genreValueLabel)
        genreValueLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        genreValueLabel.textColor = .primaryColor
        genreValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreValueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            genreValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            genreValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupReleasedLabel() {
        contentView.addSubview(releasedValueLabel)
        releasedValueLabel.font = .systemFont(ofSize: 12.0)
        releasedValueLabel.textColor = .textColor
        releasedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releasedValueLabel.topAnchor.constraint(equalTo: genreValueLabel.bottomAnchor, constant: 4.0),
            releasedValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            releasedValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupRatingLabel() {
        contentView.addSubview(ratingValueLabel)
        ratingValueLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        ratingValueLabel.textColor = .systemYellow
        ratingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingValueLabel.topAnchor.constraint(equalTo: releasedValueLabel.bottomAnchor, constant: 8.0),
            ratingValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            ratingValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupDescLabel() {
        descTitle.font = .systemFont(ofSize: 14.0)
        descTitle.textColor = .primaryColor
        descTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descTitle)
        NSLayoutConstraint.activate([
            descTitle.topAnchor.constraint(equalTo: ratingValueLabel.bottomAnchor, constant: 24.0),
            descTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            descTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
        
        descValueLabel.font = .systemFont(ofSize: 14.0)
        descValueLabel.textColor = .textColor
        descValueLabel.numberOfLines = 20
        descValueLabel.textAlignment = .justified
        descValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descValueLabel)
        NSLayoutConstraint.activate([
            descValueLabel.topAnchor.constraint(equalTo: descTitle.bottomAnchor, constant: 4.0),
            descValueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            descValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupDeveloperLabel() {
        developerTitle.font = .systemFont(ofSize: 14.0)
        developerTitle.textColor = .primaryColor
        developerTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(developerTitle)
        NSLayoutConstraint.activate([
            developerTitle.topAnchor.constraint(equalTo: descValueLabel.bottomAnchor, constant: 16.0),
            developerTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            developerTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
        
        developerLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        developerLabel.textColor = .textColor
        developerLabel.numberOfLines = 0
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(developerLabel)
        NSLayoutConstraint.activate([
            developerLabel.topAnchor.constraint(equalTo: developerTitle.bottomAnchor, constant: 4.0),
            developerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            developerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupPublisherLabel() {
        publisherTitle.font = .systemFont(ofSize: 14.0)
        publisherTitle.textColor = .primaryColor
        publisherTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(publisherTitle)
        NSLayoutConstraint.activate([
            publisherTitle.topAnchor.constraint(equalTo: developerLabel.bottomAnchor, constant: 16.0),
            publisherTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            publisherTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
        
        publisherLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        publisherLabel.textColor = .textColor
        publisherLabel.numberOfLines = 0
        publisherLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(publisherLabel)
        NSLayoutConstraint.activate([
            publisherLabel.topAnchor.constraint(equalTo: publisherTitle.bottomAnchor, constant: 4.0),
            publisherLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            publisherLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            publisherLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 32.0)
        ])
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.color = .textColor
            self.contentView.addSubview(self.activityIndicator)
            NSLayoutConstraint.activate([
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    func showErrorAlert(message: String?) {
        let alert = UIAlertController(
            title: "Error",
            message: message ?? "Something's wrong!\nPlease check your connection and retry.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.getGameDetail()
            self.getFavoriteStatus()
        }))
        present(alert, animated: true, completion: nil)
    }
}
