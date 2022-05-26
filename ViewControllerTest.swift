//
//  ViewController.swift
//  StaticFactoryMethodsToConfigureLayout
//
//  Created by Kaike Facchina on 15/05/22.
//

import UIKit

/**
 
 Intuito: Separar código de configuração do código de lógica
 É preferível utilizar extensions para configurações de layouts ao invés de subclasses.
 A abordagem de criar subclasses é mais interessante de utilizar quando temos comportamentos diferentes para além do layout.
 
 https://www.swiftbysundell.com/articles/static-factory-methods-in-swift/
 **/


final class ButtonView: UIView {
    
    private lazy var stack: UIStackView = {
        let stack: UIStackView = .init()
        stack.spacing = .zero
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let buttons: [UIButton]
    
    private lazy var line: UIView = {
        let line: UIView = .init()
        line.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
    }()
    
    init(buttons: [UIButton]) {
        self.buttons = buttons
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        stack.addArrangedSubview(buttons.first!)
        stack.addArrangedSubview(buttons.last!)
        stack.addArrangedSubview(line)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class ViewController: UIViewController {
    
    private let titleLabel: UILabel = .makeTitle()
    private lazy var buttons: ButtonView = .init(buttons: [makeButton(color: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), text: "Continuar",
                                                                      textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
                                                           makeButton(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "Fechar",
                                                                      textColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1))])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Kaike"
        view.addSubview(titleLabel)

        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(titleTapped))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttons.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        requestSimulation()
    }
    
    func requestSimulation() {
        let loadingViewController: UIViewController = .makeLoading()
        view.addSubview(loadingViewController.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            loadingViewController.view.removeFromSuperview()
        }
    }
    
    @objc func titleTapped() {
        let nextViewController: NextViewController = .init()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func makeButton(color: UIColor, text: String, textColor: UIColor) -> UIButton {
        let button: UIButton = .init()
        button.backgroundColor = color
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true

        return button
    }
}

extension UILabel {
    static func makeTitle() -> UILabel {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
}

extension UIViewController {
    static func makeLoading() -> UIViewController {
        let viewController = UIViewController()

        let indicator: UIActivityIndicatorView = .init(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        viewController.view.addSubview(indicator)
        viewController.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(
                equalTo: viewController.view.centerXAnchor
            ),
            indicator.centerYAnchor.constraint(
                equalTo: viewController.view.centerYAnchor
            )
        ])
    
        return viewController
    }
}
