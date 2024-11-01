//
//  DetailViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import UIKit
import Combine
import SDWebImage

final class DetailViewController: UIViewController {
    
    // MARK: - Views -
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        return view
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let posterButton = UIButton()
    
    private let overviewContainer = UIView()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let infoView = MovieInfoView()
    
    // MARK: - Viewmodel -
    private var viewModel: DetailViewModelProtocol
    
    // MARK: - Properties -
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle -
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        viewModel.onViewDidLoad()
        setupUI()
    }
    
}

private extension DetailViewController {
    
    // MARK: - Setup Methods -
    func setupUI() {
        setupScrollView()
        view.backgroundColor = .white
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.large
        posterView.clipsToBounds = true
        posterView.snp.makeConstraints { make in
            make.height.equalTo(550)
        }
        posterView.addSubview(posterButton)
        posterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        posterButton.addTarget(self, action: #selector (posterButtonTapped), for: .touchUpInside)
    }
    
    func setupScrollView() {
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(margins)
        }
        scrollStackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        configureContainerView()
    }
    
    private func configureContainerView() {
        scrollStackViewContainer.addArrangedSubview(posterView)
        scrollStackViewContainer.addArrangedSubview(infoView)
        scrollStackViewContainer.addArrangedSubview(overviewContainer)
        overviewContainer.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        scrollStackViewContainer.setCustomSpacing(16, after: infoView)
    }
    
    func configure(detail: MovieDetail, video: VideoResult?) {
        navigationItem.title = detail.title
        let url = URL(string: ("https://image.tmdb.org/t/p/w500" + (detail.posterPath ?? "")))
        posterView.sd_setImage(with: url)
        let country = detail.originCountry?.compactMap { $0 }.joined(separator: ", ") ?? ""
        let year = getYear(from: detail.releaseDate ?? "")
        let genres = detail.genres?.compactMap(\.name).joined(separator: ", ")
        let rating = detail.voteAverage ?? 0.0
        let formattedRating = String(format: "%.1f", rating)
        infoView.configure(title: detail.title,
                           subtitle: country + ", " + year,
                           genre: genres ?? "",
                           rating: formattedRating,
                           isYoutubeButtonHidden: video == nil) { [weak self] in
            guard let key = video?.key else { return }
            self?.viewModel.openTrailer(key: key)
        }
        overviewLabel.text = detail.overview
    }
    
    // MARK: - Actions -
    @objc private func posterButtonTapped() {
        print("tap")
        guard let image = posterView.image else { return }
        viewModel.openImageDetail(for: image)
    }
}

// MARK: - Subscriptions -
private extension DetailViewController {
    func setupSubscriptions() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.renderState(state)
            }
            .store(in: &cancellables)
        
        viewModel.viewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handleAction(action)
            }
            .store(in: &cancellables)
        
    }
    
    func renderState(_ state: DetailModel.ViewState) {
        switch state {
        case let .loaded(detail, video):
            configure(detail: detail, video: video)
        case .loading:
            break
        }
        
    }
    
    func handleAction(_ action: DetailModel.ViewAction) {
        switch action {
        case let .showError(error):
            showAlert(error.localizedDescription)
        }
    }
}

// MARK: - Flow -
private extension DetailViewController {
    func getYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return String(year)
    }
}
