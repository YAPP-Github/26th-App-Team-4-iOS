//
//  RecordDetailViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

public final class RecordDetailViewController: BaseViewController, View, CustomAlertViewDelegate {
  private var mapView: NMFMapView?

  public typealias Reactor = RecordDetailReactor

  enum Section: Int, CaseIterable {
    case title
    case goalAchievement
    case runRecord
    case runningCourse
    case lapSegment
  }

  weak var coordinator: RecordDetailCoordinator?

  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }

  private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = FRColor.Bg.secondary
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.sectionHeaderTopPadding = 0

    $0.registerCell(ofType: RecordDetailTitleTableCell.self)
    $0.registerCell(ofType: RecordDetailAchievementTableCell.self)
    $0.registerCell(ofType: RecordDetailRecordTableCell.self)
    $0.registerCell(ofType: RecordDetailCourseTableCell.self)
    $0.registerCell(ofType: RecordDetailLapTableCell.self)

    $0.delegate = self
    $0.dataSource = self
  }

  private let deleteButton: UIButton = {
    var config = UIButton.Configuration.plain()
    config.title = "삭제하기"
    config.image = UIImage(named: "trash", in: Bundle.module, compatibleWith: nil)?.resized(to: CGSize(width: 14, height: 14))
    config.imagePlacement = .leading
    config.imagePadding = 8
    config.baseForegroundColor = FRColor.Fg.Text.secondary

    let button = UIButton(configuration: config, primaryAction: nil)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    button.backgroundColor = FRColor.Fg.Nuetral.gray400
    button.layer.cornerRadius = 12
    return button
  }()

  private lazy var popUpView = FirstRunningPopUpView().then {
    $0.isHidden = true
    $0.onConfirm = { [weak self] in
      guard let self = self else { return }
      self.coordinator?.showRunningPaceSetting()
    }
  }

  override init() {
    super.init()
    hidesBottomBarWhenPushed = true
  }

  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = FRColor.Bg.secondary
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  public override func initUI() {
    super.initUI()
    self.view.backgroundColor = FRColor.Bg.secondary

    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 84))
    footerView.backgroundColor = .clear
    footerView.addSubview(deleteButton)
    deleteButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(36)
      $0.width.equalTo(107)
    }
    tableView.tableFooterView = footerView

    view.addSubview(popUpView)
    popUpView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  public func bind(reactor: RecordDetailReactor) {
    // MARK: Action
    backButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.finish()
      }
      .disposed(by: disposeBag)

    self.rx.viewDidAppear
      .take(1)
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)

    deleteButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.showDeleteConfirmationDialog()
      }
      .disposed(by: disposeBag)

    // MARK: State
    reactor.state.map(\.detail)
      .observe(on: MainScheduler.instance)
      .subscribe(with: self) { owner, record in
        guard let record = record else { return }
        owner.tableView.reloadData()
        if record.imageUrl ?? "" == "" {
          owner.setupHiddenMap(for: record)
        }
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isDeleted)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0 == true }
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.pop()
        owner.showToast(message: "삭제가 완료되었어요.")
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.shouldShowFirstRunningPopUp)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0 == true }
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(with: self) { owner, _ in
        owner.popUpView.isHidden = false
      }
      .disposed(by: disposeBag)
  }

  private func showDeleteConfirmationDialog() {
      let alertView = CustomAlertView(
          title: "해당 기록을 삭제하시겠어요?",
          message: "삭제된 기록은 되돌릴 수 없어요."
      )
      alertView.delegate = self
      self.view.addSubview(alertView)
      alertView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  // MARK: - CustomAlertViewDelegate
  public func deleteButtonTapped() {
    guard let reactor = self.reactor else { return }
    reactor.action.onNext(.deleteRecord)
  }

  private func getAddressFrom(coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
      if error != nil {
        completion(nil)
        return
      }
      guard let placemark = placemarks?.first else {
        completion("주소 없음")
        return
      }
      var addressComponents: [String] = []
      if let administrativeArea = placemark.administrativeArea {
        addressComponents.append(administrativeArea)
      }
      if let locality = placemark.locality {
        addressComponents.append(locality)
      }
      if let thoroughfare = placemark.thoroughfare {
        addressComponents.append(thoroughfare)
      }
      let fullAddress = addressComponents.joined(separator: " ")
      completion(fullAddress.isEmpty ? "주소 없음" : fullAddress)
    }
  }

  private func showToast(message: String) {
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = .systemFont(ofSize: 14)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
}

extension RecordDetailViewController: UITableViewDelegate, UITableViewDataSource {

  public func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .title:
      return 1
    case .goalAchievement:
      guard let detail = reactor?.currentState.detail,
            (detail.isDistanceGoalAchieved || detail.isPaceGoalAchieved || detail.isTimeGoalAchieved) else {
        return 0
      }
      return 1
    case .runRecord:
      return 1
    case .runningCourse:
      return 1
    case .lapSegment:
      guard let segments = reactor?.currentState.detail?.segments else { return 0 }
      return segments.count
    case .none:
      return 0
    }
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch Section(rawValue: section) {
    case .lapSegment:
      return RecordDetailLapTableHeaderView()
    default:
      return UIView()
    }
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .lapSegment:
      return 94
    default:
      return .zero
    }
  }

  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    switch Section(rawValue: section) {
    case .lapSegment:
      return RecordDetailLapTableFooterView()
    default:
      return UIView()
    }
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .lapSegment:
      return 62
    default:
      return .zero
    }
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section) {
    case .title:
      return dequeueTitleCell(for: indexPath)
    case .goalAchievement:
      return dequeueGoalAchievementCell(for: indexPath)
    case .runRecord:
      return dequeueRecordCell(for: indexPath)
    case .runningCourse:
      return dequeRueRunningCourseCell(for: indexPath)
    case .lapSegment:
      return dequeueLapSegmentCell(for: indexPath)
    case .none:
      return UITableViewCell()
    }
  }

  private func dequeueTitleCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailTitleTableCell.identifier, for: indexPath
    ) as! RecordDetailTitleTableCell
    guard let detail = self.reactor?.currentState.detail else { return cell }
    cell.setData(
      title: detail.title,
      date: detail.startAt
    )
    return cell
  }

  private func dequeueGoalAchievementCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailAchievementTableCell.identifier, for: indexPath
    ) as! RecordDetailAchievementTableCell
    guard let detail = self.reactor?.currentState.detail else { return cell }
    cell.setData(
      distance: detail.isDistanceGoalAchieved,
      pace: detail.isPaceGoalAchieved,
      time: detail.isTimeGoalAchieved
    )
    return cell
  }

  private func dequeueRecordCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailRecordTableCell.identifier, for: indexPath
    ) as! RecordDetailRecordTableCell
    guard let detail = self.reactor?.currentState.detail else { return cell }
    cell.setData(distance: detail.totalDistance, pace: detail.averagePace, runningTime: detail.totalTime)
    return cell
  }

  private func dequeRueRunningCourseCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailCourseTableCell.identifier, for: indexPath
    ) as! RecordDetailCourseTableCell
    guard let detail = self.reactor?.currentState.detail else { return cell }
    if let location = detail.runningPoints.first?.location {
      let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
      getAddressFrom(coordinate: coordinate) { location in
        cell.setData(imageURL: detail.imageUrl, location: location ?? "")
      }
    } else {
      cell.setData(imageURL: detail.imageUrl, location: "")
    }
    return cell
  }

  private func dequeueLapSegmentCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailLapTableCell.identifier, for: indexPath
    ) as! RecordDetailLapTableCell
    guard let segments = self.reactor?.currentState.detail?.segments else { return cell }
    guard segments.indices.contains(indexPath.row) else { return cell }
    let segment = segments[indexPath.row]
    let paceString = segment.averagePace.toMinutesAndSeconds()
    let scale = normalizedScale(for: indexPath.row, in: segments)
    let length = CGFloat(scale)
    let isPrimary = scale == 1.0
    cell.setData(lapNumber: indexPath.row + 1, lapTime: paceString, length: CGFloat(length), isPrimary: isPrimary)
    return cell
  }

  public func normalizedScale(
    for index: Int,
    in segments: [RunningSegment],
    minScale: Float = 0.35,
    maxScale: Float = 1.0
  ) -> Float {
    guard !segments.isEmpty,
          segments.indices.contains(index) else {
      return minScale
    }
    let paces = segments.map { $0.averagePace }
    guard let minPace = paces.min(),
          let maxPace = paces.max(),
          minPace < maxPace else {
      return maxScale
    }
    let pace = segments[index].averagePace
    let normalized = (maxPace - pace) / (maxPace - minPace)
    return minScale + Float(normalized) * (maxScale - minScale)
  }
}

extension RecordDetailViewController: NMFMapViewRenderDelegate {

  func setupHiddenMap(for record: RunningRecord) {
    guard mapView == nil else { return }

    let mapView = NMFMapView()
    mapView.isHidden = false
    mapView.alpha = 0
    self.view.addSubview(mapView)
    self.mapView = mapView

    mapView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(200)
    }

    mapView.addRenderDelegate(delegate: self)

    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let points = record.runningPoints.map {
        NMGLatLng(lat: $0.location.lat, lng: $0.location.lon)
      }

      if !points.isEmpty {
        let polyline = NMFPolylineOverlay(points)
        polyline?.width = 8
        polyline?.color = .systemBlue
        polyline?.mapView = mapView
        let bounds = NMGLatLngBounds(latLngs: points)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 50)
        mapView.moveCamera(cameraUpdate)
        
        reactor?.action.onNext(.mapRendered(mapView: mapView))
      }
    }
  }

  public func mapViewDidFinishRender(_ mapView: NMFMapView) {
    reactor?.action.onNext(.mapRendered(mapView: mapView))
  }
}
