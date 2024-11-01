//
//  YouTubeVideoViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 01.11.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

final class YouTubeVideoViewController: UIViewController {
    
    // MARK: - Views -
    private let playerView = YTPlayerView()
    
    // MARK: - Properties -
    private let videoKey: String
    
    // MARK: - Lifecycle -
    init(videoKey: String) {
        self.videoKey = videoKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        loadVideo()
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: - Setup Methods -
    private func setupPlayerView() {
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Flow -
    private func loadVideo() {
        LoaderView.sharedInstance.start()
        playerView.load(withVideoId: videoKey)
        LoaderView.sharedInstance.stop()
    }
    
    // MARK: - Actions -
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
