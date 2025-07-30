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
import Domain
//import Data

public final class HomeViewController: BaseViewController, View {

  weak var coordinator: HomeCoordinator?

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
    $0.textColor = FRColor.Fg.Text.primary
    $0.numberOfLines = 0
  }
  
  private let runButton = UIButton().then {
    $0.setTitle("달리기", for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.titleLabel?.textColor = FRColor.Fg.Text.Interactive.inverse
    $0.backgroundColor = FRColor.Fg.Icon.primary
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
      $0.height.equalTo(54)
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
  
  public func bind(reactor: HomeReactor) {
    self.rx.viewDidAppear
      .map { _ in Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.homeInfo)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .subscribe(with: self) { object, homeInfo in
        object.updateHomeInfo(homeInfo: homeInfo)
      }
      .disposed(by: disposeBag)
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
    
    cardView.editButton.rx.tap
      .subscribe(with: self) { object, _ in
//        let vc = PaceCountSettingViewController().then {
//          $0.reactor = PaceCountSettingReactor(goalUseCase: GoalUseCaseImpl(goalRepository: GoalRepositoryImpl()))
//        }
//        vc.hidesBottomBarWhenPushed = true
//        object.navigationController?.pushViewController(vc, animated: true)
      }
      .disposed(by: disposeBag)

    runButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.coordinator?.showRunngingFlow()
      }
      .disposed(by: disposeBag)
  }
  
  private func updateHomeInfo(homeInfo: HomeInfo) {
    titleLabel.text = message(for: homeInfo.totalDistance ?? 0)
    cardView.setData(homeInfo)
  }
  
}

extension HomeViewController {
  /// 누적 달린 거리(킬로미터)에 따라 안내 문구를 반환합니다.
  func message(for distanceKm: Double) -> String {
    let thresholds: [(km: Double, message: String)] = [
      (0,   "나에게 딱 맞는 러닝을\n핏런에서 함께해요!"),
      (0.5, "집 앞 편의점까지 한 바퀴,\n이제 시작이에요!"),
      (1,   "벌써 축구장을 두 바퀴 돌았어요.\n잘하고 있어요!"),
      (2,   "동네 한 바퀴 완주!\n지금처럼 꾸준히 달려봐요"),
      (3,   "남산에 올라왔어요!\n멋진 출발이에요"),
      (5,   "올림픽공원 한 바퀴 성공했어요\n뛸수록 가벼워져요."),
      (7,   "여의도에서 압구정까지 돌파!\n건강해지고 있어요."),
      (10,  "마포에서 강남까지 종단 성공!\n러닝 루틴이 생겼어요."),
      (12,  "도쿄 하라주쿠 쇼핑코스만큼 뛴 거예요!"),
      (15,  "한강 자전거 풀코스만큼 뛰었어요!\n멋져요"),
      (18,  "서울숲에서 경복궁까지 왕복 거리예요!"),
      (20,  "반 마라톤 거리 달성!\n매일이 성장 중이에요."),
      (25,  "광화문에서 인천까지! 대단해요."),
      (30,  "서울 도심 순환 러닝 완주한 셈이에요."),
      (35,  "부산 해운대–송정 해안선을 뛴 셈이에요."),
      (40,  "백두대간 둘레길 하루 코스를 뛰었어요"),
      (45,  "남산 타워 10번 오른 만큼 뛰어왔어요"),
      (50,  "서울–천안 종단! \n뛸수록 멘탈도 강해져요."),
      (55,  "제주 올레길 한 코스 클리어!"),
      (60,  "한라산을 두번이나 완등한 셈이에요."),
      (70,  "서울에서 충주까지 달려왔어요."),
      (80,  "대전–전주 거리만큼 뛰었어요! \n국토대장정에 도전해보세요."),
      (90,  "남한산성 8코스 다 돌았어요!"),
      (100, "국토 대장정 첫 구간 마무리를 축하해요!"),
      (120, "한반도 종단의 1/5 에 도착했어요!"),
      (150, "남도 해안길을 잇는 기록을 세웠어요!"),
      (180, "서울–대구 거리만큼 달렸어요."),
      (200, "수도권에서 강릉까지 완주한 셈이에요"),
      (250, "국토 종단의 절반, 진짜 대단해요!"),
      (300, "러너계의 무사! 전국 일주 중입니다.")
    ]
    // 가장 높은 threshold부터 내려오며 매칭
    for (km, text) in thresholds.sorted(by: { $0.km > $1.km }) {
      if distanceKm >= km {
        return text
      }
    }
    // 0 미만일 땐 첫 문구
    return thresholds[0].message
  }
  
}
