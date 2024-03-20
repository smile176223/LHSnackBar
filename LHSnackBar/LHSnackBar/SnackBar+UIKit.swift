//
//  SnackBar+UIKit.swift
//  LHSnackBar
//
//  Created by Liam on 2024/3/19.
//

import UIKit

public class SnackBarView: UIView {
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 15
        return mainStackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private var bottomConstraint = NSLayoutConstraint()
    private let model: SnackModel
    private let contentView: UIView
    
    required public init(view: UIView, model: SnackModel) {
        self.contentView = view
        self.model = model
        super.init(frame: .zero)
        setupViews()
        updateUI()
    }
    
    required public init?(coder: NSCoder) {
        nil
    }
    
    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func updateUI() {
        iconImageView.image = UIImage(systemName: model.snackType.icon)?.withRenderingMode(.alwaysTemplate)
        messageLabel.text = model.message
    }
    
    public static func make(in view: UIView, model: SnackModel) -> Self {
        removeOldViews(form: view)
        return Self.init(view: view, model: model)
    }
    
    private static func removeOldViews(form view: UIView) {
        view.subviews
            .filter({ $0 is Self })
            .forEach({ $0.removeFromSuperview() })
    }
    
    private func constraintSuperView(with view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bottomConstraint
        ])
    }
    
    private func animation(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        superview?.layoutIfNeeded()
        
        bottomConstraint.constant = offset
        
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
            self.superview?.layoutIfNeeded()
        }, completion: completion)
    }
    
    public func show() {
        constraintSuperView(with: contentView)
        animation(with: -16)
    }
    
    @objc private func viewTapped() {
        animation(with: 200) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}

extension UIView {
    public func showSnackBar(type: SnackModel.SnackType, message: String) {
        let model = SnackModel(snackType: type, message: message)
        SnackBarView.make(in: self, model: model).show()
    }
}

class TestSnackBarVC: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        view.showSnackBar(type: .network, message: "No network connection")
    }
}

@available(iOS 17.0, *)
#Preview {
    TestSnackBarVC()
}

