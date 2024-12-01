//
//  ProfileViewController.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 17/11/24.
//

import Common
import UIKit

class ProfileViewController: UIViewController {
    
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let portfolioText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        setupNavigationBar()
        setupProfileImage()
        setupNameLabel()
        setupEmailLabel()
        setupPortfolioInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileEntity.synchronize()
        nameLabel.text = ProfileEntity.name
        emailLabel.text = ProfileEntity.email
        
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
        navigationItem.title = "Profile"
        
        let editButtonBar = UIBarButtonItem(title: "Edit", image: UIImage(systemName: "square.and.arrow.up"), target: self, action: #selector(editProfile))
        navigationItem.rightBarButtonItems = [editButtonBar]
    }
    
    @objc func editProfile() {
        self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    func setupProfileImage() {
        profileImage.image = UIImage(named: "Profile", in: Bundle(identifier: "com.nafladiva.Common"), with: .none)
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = 16.0
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64.0),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 200),
            profileImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        nameLabel.textColor = .primaryColor
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16.0),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupEmailLabel() {
        emailLabel.font = .systemFont(ofSize: 14.0)
        emailLabel.textColor = .textColor
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupPortfolioInfo() {
        portfolioText.text = "See my web portfolio below!✨"
        portfolioText.font = .systemFont(ofSize: 12.0)
        portfolioText.textColor = .textColor
        portfolioText.textAlignment = .center
        portfolioText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(portfolioText)
        NSLayoutConstraint.activate([
            portfolioText.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 32.0),
            portfolioText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let portfolioButton = UIButton()
        portfolioButton.backgroundColor = .primaryColor
        portfolioButton.setTitle("Portfolio", for: .normal)
        portfolioButton.setTitleColor(.backgroundColor, for: .normal)
        portfolioButton.layer.cornerRadius = 8.0
        portfolioButton.addTarget(self, action: #selector(openPortfolio), for: .touchUpInside)
        portfolioButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(portfolioButton)
        NSLayoutConstraint.activate([
            portfolioButton.topAnchor.constraint(equalTo: portfolioText.bottomAnchor, constant: 8.0),
            portfolioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portfolioButton.widthAnchor.constraint(equalToConstant: 100),
            portfolioButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func openPortfolio() {
        let portfolioUrl = "https://nafladiva.github.io"
        if let url = URL(string: portfolioUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
