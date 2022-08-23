//
//  ListCell.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit
import Kingfisher

class ListCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textsStack = UIStackView.vertical(
        with: [
            titleLabel,
            authorLabel
        ],
        alignment: .leading,
        spacing: 8
    )

    private lazy var contentStack = UIStackView.horizontal(
        with: [
            bookImageView,
            textsStack
        ],
        alignment: .center,
        spacing: 24
    )

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    private func commonInit() {
        setup()
        setupConstraints()
    }

    private func setup() {
        contentView.backgroundColor = .white
        backgroundColor = .white

        [contentStack].forEach {
            contentView.addSubview($0)
        }

        selectionStyle = .none
    }

    private func setupConstraints() {
        contentStack.snp.makeConstraints { make in
            make.leadingMargin.trailingMargin.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        bookImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 120))
        }
    }

    func configure(_ item: ListItem) {
        titleLabel.text = item.title.capitalized
        authorLabel.text = item.author
        bookImageView.kf.setImage(with: item.imageUrl)
    }
}
