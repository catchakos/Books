//
//  DetailViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 11/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Kingfisher

protocol DetailDisplayLogic: AnyObject {
    func displayLoad(_ viewModel: Detail.Load.ViewModel)
    func displayPreview(_ viewModel: Detail.Preview.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic, DependentViewController {
    var dataStore: DependentStore? {
        return router?.dataStore
    }

    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

    // MARK: - UI Elements

    lazy var dimmedView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        view.accessibilityLabel = "dimmed_view"

        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.accessibilityLabel = "title_label"
        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .black
        label.textAlignment = .natural
        label.accessibilityLabel = "author_label"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .natural
        label.accessibilityLabel = "description_label"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        label.textColor = .black
        label.textAlignment = .natural
        label.accessibilityLabel = "publisher_label"
        return label
    }()
    
    lazy var isbnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        label.textColor = .black
        label.textAlignment = .natural
        label.accessibilityLabel = "isbn_label"
        return label
    }()
    
    lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.accessibilityLabel = "fetching_preview"
        label.text = NSLocalizedString("Fetching preview..", comment: "")
        return label
    }()
    
    lazy var previewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.blue, for: .normal)
        button.setTitle(NSLocalizedString("Preview", comment: ""), for: .normal)
        button.accessibilityLabel = "preview_button"
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var previewStack = UIStackView.horizontal(
        with: [
            previewLabel,
            previewButton
        ],
        alignment: .center)

    lazy var stack = UIStackView.vertical(
        with: [
            titleLabel,
            authorLabel,
            descriptionLabel,
            previewStack,
            publisherLabel,
            isbnLabel
        ]
    )

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupBackgroundTap()

        doLoad()
        loadBookPreview()
    }

    private func setupView() {
        [dimmedView, contentView].forEach {
            view.addSubview($0)
        }

        [stack, imageView].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }

        stack.snp.makeConstraints { make in
            make.bottomMargin.equalToSuperview()
            make.leadingMargin.trailingMargin.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        previewStack.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func setupBackgroundTap() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap(_:)))
        dimmedView.addGestureRecognizer(tap)
    }
 
    // MARK: - Load Use Case

    func doLoad() {
        let request = Detail.Load.Request()
        interactor?.doLoad(request)
    }

    func displayLoad(_ viewModel: Detail.Load.ViewModel) {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        descriptionLabel.text = viewModel.descriptionText
        isbnLabel.text = viewModel.isbn
        publisherLabel.text = viewModel.publisher
        
        imageView.kf.setImage(with: viewModel.imageUrl)
    }
    
    // MARK: - Preview Use Case

    func loadBookPreview() {
        let request = Detail.Preview.Request()
        interactor?.loadPreview(request)
    }
    
    func displayPreview(_ viewModel: Detail.Preview.ViewModel) {
        if viewModel.hasPreview {
            previewButton.isHidden = false
            previewLabel.isHidden = true
        } else {
            previewButton.isHidden = true
            previewLabel.isHidden = false
            previewLabel.text = NSLocalizedString("No preview", comment: "")
        }
    }
    
    // MARK: - Actions
    @objc func didTap(_: UITapGestureRecognizer) {
        router?.exitDetail()
    }
    
    @objc func didTapPreview() {
        router?.routeToPreview()
    }
}

extension DetailViewController: CustomPresentedViewController {
    var containerViewForCustomPresentation: UIView {
        return contentView
    }

    var backgroundViewForCustomPresentation: UIView {
        return dimmedView
    }
}
