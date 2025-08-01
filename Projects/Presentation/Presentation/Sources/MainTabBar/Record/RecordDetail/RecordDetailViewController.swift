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

public final class RecordDetailViewController: BaseViewController, View {
  
  public typealias Reactor = RecordDetailReactor
  
  enum Section: Int, CaseIterable {
    case title
    case goalAchievement
    case runRecord
    case runningCourse
    case lapSegment
  }
  
  weak var coordinator: RecordCoordinator?
  
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

  private lazy var popUpView = FirstRunningPopUpView().then {
//    $0.isHidden = true
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

    bind()
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
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }

    view.addSubview(popUpView)
    popUpView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func bind() {
    backButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.coordinator?.dismissRunningFlow()
      }
      .disposed(by: disposeBag)
  }
  
  public func bind(reactor: RecordDetailReactor) {
    self.rx.viewDidAppear
      .take(1)
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.detail)
      .observe(on: MainScheduler.instance)
      .subscribe(with: self) { owner, record in

        guard let record = record else { return }
        owner.tableView.reloadData()
      }
      .disposed(by: disposeBag)
  }
  
  public override func action() {
    super.action()
    
    backButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
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
  
  // 모든 섹션 푸터 없애기
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
    cell.setData(title: detail.title, date: detail.startAt)
    return cell
  }
  
  private func dequeueGoalAchievementCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailAchievementTableCell.identifier, for: indexPath
    ) as! RecordDetailAchievementTableCell
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
    cell.setData(imageURL: "", location: "종로구 서울특별시 대한민국")
    return cell
  }
  
  private func dequeueLapSegmentCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailLapTableCell.identifier, for: indexPath
    ) as! RecordDetailLapTableCell
    guard let segments = self.reactor?.currentState.detail?.segments else { return cell }
    guard segments.indices.contains(indexPath.row) else { return cell }
    
    let segment = segments[indexPath.row]
    let lapNumber = segment.orderNo
    
    let paceString = segment.averagePace.minuteSecondFormatted

    let scale = normalizedScale(for: indexPath.row, in: segments)
    let length = CGFloat(scale)
    
    let isPrimary = scale == 1.0
    
    cell.setData(lapNumber: indexPath.row + 1, lapTime: paceString, length: CGFloat(length), isPrimary: isPrimary)
    print("\(type(of: self)) - \(#function)", indexPath, scale)
    return cell
  }
  
  
  public func normalizedScale(
    for index: Int,
    in segments: [RecordSegment],
    minScale: Float = 0.35,
    maxScale: Float = 1.0
  ) -> Float {
    // 안전성 검사
    guard !segments.isEmpty,
          segments.indices.contains(index) else {
      return minScale
    }

    // 모든 페이스 값 추출
    let paces = segments.map { $0.averagePace }
    guard let minPace = paces.min(),
          let maxPace = paces.max(),
          minPace < maxPace else {
      // 모든 값이 동일하면 가장 빠른 값 스케일로
      return maxScale
    }

    // 타겟 segment 페이스
    let pace = segments[index].averagePace

    // faster (작은 페이스) → 큰 normalized, slower (큰 페이스) → 작은 normalized
    let normalized = (maxPace - pace) / (maxPace - minPace)

    // minScale…maxScale 구간으로 매핑
    return minScale + Float(normalized) * (maxScale - minScale)
  }
  
}
