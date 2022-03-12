//
//  ListCell.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class ListCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textsStack = UIStackView.vertical(
        with: [
            titleLabel
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
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.greaterThanOrEqualTo(80)
        }
    }

    func configure(_ item: ListItem) {
        titleLabel.text = item.title.capitalized
    }

}
