//
//  PlanetTableViewCell.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import UIKit
import SnapKit

class PlanetTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func buildUI() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(climateLabel)
        
        self.nameLabel.snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(16)
        }
        
        self.climateLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(16)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        DesignSystem.shared.styles.headerLabel(label)
        return label
    }()
    
    private lazy var climateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        DesignSystem.shared.styles.description(label)
        return label
    }()
}

extension PlanetTableViewCell: CellConfigurable {
    func configure(with viewModel: PlanetCellViewModel) {
        self.nameLabel.text = viewModel.name
        self.climateLabel.text = viewModel.climate
    }
}

struct PlanetCellViewModel {
    let planet: Planet
    
    var name: String {
        planet.name
    }
    
    var climate: String {
        planet.climate
    }
}

extension PlanetCellViewModel: Hashable {
    static func == (lhs: PlanetCellViewModel, rhs: PlanetCellViewModel) -> Bool {
        (lhs.planet.name == rhs.planet.name)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.planet.name)
    }
}
