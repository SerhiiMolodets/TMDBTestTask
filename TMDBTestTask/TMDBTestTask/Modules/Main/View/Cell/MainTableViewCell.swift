//
//  MainTableViewCell.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 30.10.2024.
//

import UIKit
import SnapKit
import SDWebImage

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Views -
    private let containerView = UIView()
    
    private let posterView = UIImageView()
    
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    private let shadowView = UIView()
 
    
    // MARK: - Lifecycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI -
    private func setupUI() {
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(shadowView)
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        shadowView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        shadowView.addSubview(containerView)
        containerView.addSubview(posterView)
        posterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(500)
        }
        
        posterView.addSubview(titleLabel)
        posterView.addSubview(genreLabel)
        posterView.addSubview(ratingLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        genreLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(ratingLabel.snp.leading)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 8
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.backgroundColor = .black.withAlphaComponent(0.5)
        genreLabel.backgroundColor = .black.withAlphaComponent(0.5)
        ratingLabel.backgroundColor = .black.withAlphaComponent(0.5)
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        genreLabel.textColor = .white
        ratingLabel.textColor = .white
    }
    
    // MARK: - Configure -
    func set(item: MovieResult) {
        titleLabel.text = item.title

        ratingLabel.text = "\(item.voteAverage ?? 0.0)"
        let url = URL(string: ("https://image.tmdb.org/t/p/w500" + (item.posterPath ?? "")))
        posterView.sd_setImage(with: url)
    }
    
    func setGenres(titles: String) {
        genreLabel.text = titles
    }
}
