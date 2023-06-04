//
//  ViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.02.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let emitterLayer = CAEmitterLayer()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.maximumNumberOfTouches = 1
        return gesture
    }()
    private lazy var tapGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.minimumPressDuration = 0
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    
    private var keyboardRect: CGRect?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObserver()
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmitterLayer()
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
    
    deinit {
        ApplicationLogger.instance?.printCalled(viewControllerName: "\(Self.self)", method: #function)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - Animation

private extension BaseViewController {
    func setupEmitterLayer() {
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: 1, height: 1)
        emitterLayer.renderMode = .additive
        emitterLayer.birthRate = 0
        
        let particle = CAEmitterCell()
        particle.contents = UIImage(named: "ic_tinkoff")?.cgImage
        particle.birthRate = 3
        particle.lifetime = 1
        particle.velocity = 5
        particle.scale = 0.04
        particle.scaleRange = 0.1
        particle.velocityRange = 30
        particle.emissionRange = .pi * 2
        particle.alphaRange = -0.2
        particle.alphaSpeed = -1
        
        emitterLayer.emitterCells = [particle]
        view.layer.addSublayer(emitterLayer)
    }
    
    func showParticles(at position: CGPoint) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        emitterLayer.emitterPosition = position
        CATransaction.commit()
    }
    
    @objc func viewTapped(gesture: UIGestureRecognizer) {
        if let view = gesture.view,
           let window = view.window,
           let keyboardRect, keyboardRect.contains(gesture.location(in: window)) {
            emitterLayer.birthRate = 0
            return
        }
        
        switch gesture.state {
        case .began:
            emitterLayer.birthRate = 1
            showParticles(at: gesture.location(in: view))
        case .changed:
            emitterLayer.birthRate = 4
            showParticles(at: gesture.location(in: view))
        default:
            emitterLayer.birthRate = 0
        }
    }
}

// MARK: - Keyboard Observer

private extension BaseViewController {
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(baseKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func baseKeyboardWillShow(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.keyboardRect = keyboardRect
    }
}
