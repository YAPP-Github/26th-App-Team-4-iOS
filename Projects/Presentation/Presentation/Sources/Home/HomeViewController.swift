//
//  HomeViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/18/25.
//


import UIKit
import Core
import ReactorKit
import NMapsMap

public final class HomeViewController: BaseViewController {
  
  private let cardContainerView = UIView().then {
    $0.backgroundColor = UIColor(hex: "#F5F5F9")
    $0.layer.cornerRadius = 20
    $0.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]
    $0.clipsToBounds = true
    $0.addShadow(Opacity: 0.3, Offset: .zero, radius: 35)
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "나에게 딱 맞는 러닝을\n핏런에서 함께해요!"
    $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    $0.textColor = FRColor.FG.Text.primary
    $0.numberOfLines = 0
  }
  
  private let runButton = UIButton().then {
    $0.setTitle("달리기", for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.titleLabel?.textColor = FRColor.FG.Text.Interactive.inverse
    $0.backgroundColor = FRColor.FG.Icon.primary
    $0.layer.cornerRadius = 50
  }
  
  let cardView = WeeklyRunningGoalCardView()
  
  let mapView = NMFMapView(frame: .zero).then {
    $0.positionMode = .direction
    $0.locationOverlay.hidden = false
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    FRLocationManager.shared.requestAuthorization()
  }
  
  public override func initUI() {
    super.initUI()
    self.navigationController?.navigationBar.isHidden = true
    
    view.backgroundColor = .white
    
    view.addSubview(mapView)
    
    view.addSubview(cardContainerView)
    cardContainerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    cardContainerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    cardContainerView.addSubview(cardView)
    cardView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(24)
    }
    
    view.addSubview(runButton)
    runButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    mapView.moveCamera(.withZoomIn())
    mapView.snp.makeConstraints {
      $0.top.equalTo(cardContainerView.snp.bottom).offset(-12)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  public override func action() {
    super.action()
    
    FRLocationManager.shared.location
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] location in
        print("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        guard let self = self else { return }

        let latLng = NMGLatLng(lat: location.coordinate.latitude,
                               lng: location.coordinate.longitude)

        self.mapView.positionMode = .direction
        self.mapView.locationOverlay.hidden = false
        self.mapView.locationOverlay.location = latLng

        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .easeIn
        self.mapView.moveCamera(cameraUpdate)
      })
      .disposed(by: disposeBag)
  }
}
