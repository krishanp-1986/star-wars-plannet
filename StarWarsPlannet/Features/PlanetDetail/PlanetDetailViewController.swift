//
//  PlanetDetailViewController.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import UIKit

class PlanetDetailViewController: BaseViewController<NSNull> {
    init(with name: String, orbitalPeriod: String, gravity: String) {
        super.init(nibName: nil, bundle: nil)
        buildUI()
        self.nameLabel.text = name
        self.oribitalPeriodLabel.text = orbitalPeriod
        self.gravityLabel.text = gravity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.view.addSubview(containerStackView)

        let safeAreaLayoutGuilde = self.view.safeAreaLayoutGuide
        containerStackView.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuilde)
        }
    }
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, oribitalPeriodLabel, gravityLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var oribitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var gravityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
}
