//
//  MovieInfoView.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 01.11.2024.
//

import UIKit

final class MovieInfoView: UIView {
    
    // MARK: - Views -
    private let iconButton: UIButton = {
        let button = UIButton()
        button.setImage(.youtube, for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Properties -
    var onYoutubeDidTap: (() -> Void)?
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods -
    private func setupView() {
        addSubview(iconButton)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(genreLabel)
        addSubview(ratingLabel)
        
        iconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(16)
        }
        
        iconButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(ratingLabel)
            make.size.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String,
                   subtitle: String,
                   genre: String,
                   rating: String,
                   isYoutubeButtonHidden: Bool,
                   onYoutubeDidTap: (() -> Void)?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        genreLabel.text = genre
        ratingLabel.text = "detail_raing".localized() + rating
        iconButton.isHidden = isYoutubeButtonHidden
        self.onYoutubeDidTap = onYoutubeDidTap
    }
    
    // MARK: - Actions -
    @objc private func iconButtonTapped() {
        onYoutubeDidTap?()
    }
}
