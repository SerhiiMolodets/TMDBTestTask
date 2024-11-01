//
//  LoaderView.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//
import Foundation
import UIKit

final class LoaderView: UIView {
    
    // MARK: - Properties -
    static let sharedInstance = LoaderView()
    
    private let lineWidth: CGFloat = 6.0
    private let circleSize: CGSize = CGSize(width: 80.0, height: 80.0)
    private var circleLayer : CAShapeLayer?
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDelegate = scene?.delegate as? SceneDelegate,
              let currentWindow = sceneDelegate.appCoordinator?.window else {
            super.init(frame: .zero)
            return
        }
        super.init(frame: currentWindow.frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup Methods -
    private func setup() {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDelegate = scene?.delegate as? SceneDelegate,
              let currentWindow = sceneDelegate.appCoordinator?.window else {return}
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.circleLayer = CAShapeLayer()
        self.circleLayer?.strokeColor = UIColor.gray.cgColor
        self.circleLayer?.fillColor = UIColor.clear.cgColor
        self.circleLayer?.lineCap = CAShapeLayerLineCap.round
        self.circleLayer?.lineWidth = lineWidth
        let position = CGPoint(x: (currentWindow.frame.width - circleSize.width)/2.0, y: (currentWindow.frame.height - circleSize.height)/2.0)
        self.circleLayer?.frame = CGRect(origin: position, size: circleSize)
        self.layer.addSublayer(self.circleLayer!)
    }
    
    private func drawBackgroundCircle(partial : Bool) {
        let startAngle : CGFloat = CGFloat.pi / CGFloat(2.0)
        var endAngle : CGFloat = (2.0 * CGFloat.pi) + startAngle
        
        let center : CGPoint = CGPoint(x: circleSize.width / 2,y: circleSize.height / 2)
        let radius : CGFloat = (CGFloat(circleSize.width) - lineWidth) / CGFloat(2.0)
        
        let processBackgroundPath : UIBezierPath = UIBezierPath()
        processBackgroundPath.lineWidth = lineWidth
        
        if (partial) {
            endAngle = (1.75 * CGFloat.pi) + startAngle
        }
        processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer?.path = processBackgroundPath.cgPath;
    }

    // MARK: - Flow -
    func start(on view: UIView? = nil) {
        self.alpha = 0
        self.drawBackgroundCircle(partial: true)
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = HUGE;
        circleLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDelegate = scene?.delegate as? SceneDelegate,
              let currentWindow = sceneDelegate.appCoordinator?.window else { return }
        (view ?? currentWindow).addSubview(self)
        self.layer.zPosition = 999
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finish) in
            self.circleLayer?.removeAllAnimations()
            self.removeFromSuperview()
        }
    }
    
    func stopImmediately() {
        self.alpha = 0
        self.circleLayer?.removeAllAnimations()
        self.removeFromSuperview()
    }
}
