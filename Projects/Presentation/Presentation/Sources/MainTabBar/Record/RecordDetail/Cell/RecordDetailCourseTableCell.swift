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
  
  // MARK: - Root Stack
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
  
  // MARK: - Title
  private lazy var titleStack = UIStackView(
    arrangedSubviews: [courseTitleLabel, locationLabel]
  ).then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = 4
  }
  private let courseTitleLabel = UILabel().then { // 24
    $0.text = "러닝 코스"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.FG.Text.primary
  }
  
  // MARK: - Location
  private let locationLabel = UILabel().then { // 20
    $0.text = "종로구 서울특별시 대한민국"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  // MARK: - Map Container
  private let mapContainer = UIView().then {
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  
  let mapView = NMFMapView(frame: .zero).then {
    $0.positionMode = .direction
    $0.locationOverlay.hidden = true
  }
  
  public func setData(imageURL: String, location: String) {
    locationLabel.text = location
    
    // Assuming you have a method to load the image into the mapView
    // loadImageIntoMapView(imageURL: imageURL)
  }
  
  // MARK: - Life Cycle
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = FRColor.Base.grey
    
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
    
    mapContainer.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    mapContainer.snp.makeConstraints {
      $0.height.equalTo(150)
    }
  }
}
