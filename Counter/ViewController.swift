//
//  ViewController.swift
//  Counter
//
//  Created by MIKHAIL SOMOV on 08.10.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countButton: UIButton!
    
    private var countNumber: Int = 0 {
        didSet {
            updateCountLabel()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGradientBackground()
    }
    
    // MARK: - Actions
    @IBAction private func countButtonTouched(_ sender: UIButton) {
        countNumber += 1
        addSparks(at: sender.center)
        addFallingDigitAnimation()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        updateCountLabel()
        countButton.layer.cornerRadius = countButton.frame.height / 2
        countButton.clipsToBounds = true
        countButton.layer.borderColor = UIColor.white.cgColor
        countButton.layer.borderWidth = 1.0
        countLabel.layer.borderWidth = 1.0
        countLabel.layer.borderColor = UIColor.white.cgColor
        countLabel.layer.cornerRadius = countLabel.frame.height / 2
    }
    
    private func updateCountLabel() {
        countLabel.text = "Count value: \(countNumber)"
    }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addSparks(at position: CGPoint) {
        let sparkEmitter = CAEmitterLayer()
        sparkEmitter.emitterPosition = position
        sparkEmitter.emitterShape = .circle
        sparkEmitter.emitterSize = CGSize(width: 10, height: 10)
        
        let sparkCell = CAEmitterCell()
        sparkCell.contents = UIImage(systemName: "star.fill")?.cgImage
        sparkCell.color = UIColor.white.cgColor
        sparkCell.birthRate = 100
        sparkCell.lifetime = 0.5
        sparkCell.velocity = 150
        sparkCell.velocityRange = 50
        sparkCell.scale = 0.05
        sparkCell.scaleRange = 0.02
        sparkCell.emissionRange = .pi * 2
        sparkCell.alphaSpeed = -1.0
        
        sparkEmitter.emitterCells = [sparkCell]
        view.layer.addSublayer(sparkEmitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sparkEmitter.removeFromSuperlayer()
        }
    }
    
    private func addFallingDigitAnimation() {
        let digitLabel = UILabel()
        digitLabel.text = "\(countNumber)"
        digitLabel.font = UIFont.systemFont(ofSize: 40)
        digitLabel.textColor = .white
        digitLabel.sizeToFit()
        digitLabel.center = CGPoint(x: countLabel.center.x, y: countLabel.center.y)
        view.addSubview(digitLabel)
        
        UIView.animate(withDuration: 2.0, animations: {
            digitLabel.center = CGPoint(x: digitLabel.center.x, y: self.view.bounds.height)
            digitLabel.alpha = 0.0
        }) { _ in
            digitLabel.removeFromSuperview()
        }
    }
}
