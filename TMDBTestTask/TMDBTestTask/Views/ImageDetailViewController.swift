//
//  ImageDetailViewController.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 01.11.2024.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    
    private let image: UIImage
    
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImageView()
        imageView.isUserInteractionEnabled = true
        view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
            swipeGesture.direction = .down
            view.addGestureRecognizer(swipeGesture)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
