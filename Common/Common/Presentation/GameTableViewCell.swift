//
//  GameTableViewCell.swift
//  Common
//
//  Created by Nafla Diva Syafia on 30/11/24.
//

import UIKit

public class GameTableViewCell: UITableViewCell {
    public let cellImageView = UIImageView()
    public let nameLabel = UILabel()
    public let releasedLabel = UILabel()
    public let genreLabel = UILabel()
    public let ratingLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellImage()
        setupNameLabel()
        setupGenreLabel()
        setupReleasedLabel()
        setupRatingLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCellImage() {
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 8.0
        cellImageView.backgroundColor = .grText
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            cellImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            cellImageView.widthAnchor.constraint(equalToConstant: 80.0),
            cellImageView.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }

    func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        nameLabel.textColor = .grText
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            nameLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 8.0),
            nameLabel.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: 16.0)
        ])
    }

    func setupGenreLabel() {
        genreLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        genreLabel.textColor = .grPrimary
        genreLabel.numberOfLines = 0
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.0),
            genreLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 8.0),
            genreLabel.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: 16.0)
        ])
    }

    func setupReleasedLabel() {
        releasedLabel.font = .systemFont(ofSize: 11.0)
        releasedLabel.textColor = .grText
        releasedLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(releasedLabel)
        NSLayoutConstraint.activate([
            releasedLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4.0),
            releasedLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 8.0),
            releasedLabel.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: 16.0)
        ])
    }

    func setupRatingLabel() {
        ratingLabel.font = .systemFont(ofSize: 11.0, weight: .semibold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: releasedLabel.bottomAnchor, constant: 4.0),
            ratingLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 8.0),
            ratingLabel.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: 16.0)
        ])
    }
}
