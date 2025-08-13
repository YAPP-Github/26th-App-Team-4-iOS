//
//  RecordDetailCourseTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public class RecordDetailCourseTableCell: BaseTableViewCell {
  private lazy var rootStack = UIStackView(
    arrangedSubviews: [
      titleStack,
      mapContainer
    ]
  ).then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layer.cornerRadius = 16
    $0.backgroundColor = .white
  }

  private lazy var titleStack = UIStackView(
    arrangedSubviews: [courseTitleLabel, locationLabel]
  ).then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = 4
  }
  private let courseTitleLabel = UILabel().then {
    $0.text = "러닝 코스"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }

  // MARK: - Location
  private let locationLabel = UILabel().then {
    $0.text = ""
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
  }

  // MARK: - Map Container
  private let mapContainer = UIView().then {
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }

  private let mapImageView = UIImageView().then {
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .systemGray6
  }

  public func setData(imageURL: String?, location: String) {
    locationLabel.text = location

    guard let imageURL = imageURL else { return }

    if let url = URL(string: imageURL), !imageURL.isEmpty {
      URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        guard let self = self,
              let data = data,
              error == nil,
              let image = UIImage(data: data) else {
          DispatchQueue.main.async {
            self?.mapImageView.image = nil
          }
          return
        }

        DispatchQueue.main.async {
          self.mapImageView.image = image
        }
      }.resume()
    } else {
      self.mapImageView.image = nil
    }
  }

  // MARK: - Life Cycle
  public override func initUI() {
    super.initUI()

    contentView.backgroundColor = .clear

    contentView.addSubview(rootStack)
    rootStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(28)
    }

    courseTitleLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }

    locationLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }

    mapContainer.addSubview(mapImageView)
    mapImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    mapContainer.snp.makeConstraints {
      $0.height.equalTo(150)
    }
  }
}
