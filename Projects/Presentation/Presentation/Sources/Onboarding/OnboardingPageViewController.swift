//
//  OnboardingPageViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/12/25.
//


import UIKit
import RxSwift
import Then
import SnapKit

import Core

public final class OnboardingPageViewController: BaseViewController {
  
  private let step: OnboardingStep
  private var visibleQuestions: [OnboardingQuestion] = []
  private var selectedOptionIndex: [OnboardingQuestion:Int] = [:]
  public let selection = PublishSubject<(OnboardingQuestion, Int)>()

  private let guideLabel = UILabel().then {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.numberOfLines = 0
  }

  private lazy var tableView = UITableView(
    frame: .zero,
    style: .grouped
  ).then {
    $0.registerCell(ofType: OnboardingAnswerTableCell.self)
    $0.register(
      OnboardingSectionHeaderView.self,
      forHeaderFooterViewReuseIdentifier: OnboardingSectionHeaderView.identifier
    )
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.estimatedRowHeight = 76
    $0.rowHeight = UITableView.automaticDimension
    $0.dataSource = self
    $0.delegate = self
  }

  public init(step: OnboardingStep) {
    self.step = step
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func initUI() {
    super.initUI()
    // 처음에는 마지막 질문만 표시
    visibleQuestions = [step.questions.last!]
    view.backgroundColor = .white

    view.addSubview(guideLabel)
    guideLabel.text = step.guideText
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(guideLabel.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func revealPreviousSection() {
    guard
      let first = visibleQuestions.first,
      let idx = step.questions.firstIndex(of: first),
      idx > 0
    else {
      return
    }

    let prev = step.questions[idx - 1]
    let oldOffsetY = tableView.contentOffset.y

    // 데이터만 업데이트
    visibleQuestions.insert(prev, at: 0)

    // 애니메이션 없이 섹션 추가
    tableView.performBatchUpdates({
      tableView.insertSections(IndexSet(integer: 0), with: .none)
    }, completion: nil)

    // 삽입 직후 기존 위치에서 header 만큼 내려놓고
    tableView.contentOffset = CGPoint(x: 0, y: oldOffsetY)

    // 부드럽게 원래 위치로 스크롤
    UIView.animate(withDuration: 1) {
      self.tableView.contentOffset = CGPoint(x: 0, y: oldOffsetY)
    }
  }
}

extension OnboardingPageViewController: UITableViewDataSource {
  public func numberOfSections(
    in tableView: UITableView
  ) -> Int {
    visibleQuestions.count
  }

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    visibleQuestions[section].options.count
  }

  public func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: OnboardingSectionHeaderView.identifier
    ) as! OnboardingSectionHeaderView
    let question = visibleQuestions[section]
    header.configure(title: question.title)
    return header
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: OnboardingAnswerTableCell.identifier,
      for: indexPath
    ) as! OnboardingAnswerTableCell
    
    let question = visibleQuestions[indexPath.section]
    let option = question.options[indexPath.row]
    let iconText = question.iconText[indexPath.row]
    let isSelected = (selectedOptionIndex[question] == indexPath.row)
    
    cell.setData(iconText: iconText, title: option, selected: isSelected)
    return cell
  }
  
  public func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    guard let answerCell = cell as? OnboardingAnswerTableCell else { return }
    let question = visibleQuestions[indexPath.section]
    let isSelected = (selectedOptionIndex[question] == indexPath.row)
    answerCell.setIsSelected(isSelected: isSelected)
  }
}

extension OnboardingPageViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)

    let question = visibleQuestions[indexPath.section]
    let optionIndex = indexPath.row
    
    let isFirstSelection = (selectedOptionIndex[question] == nil)

    // 이전 선택 해제
    if let oldIdx = selectedOptionIndex[question],
       oldIdx != optionIndex,
       let oldCell = tableView.cellForRow(
         at: IndexPath(row: oldIdx, section: indexPath.section)
       ) as? OnboardingAnswerTableCell {
      oldCell.setIsSelected(isSelected: false)
    }

    // 새 선택 적용
    selectedOptionIndex[question] = optionIndex
    if let newCell = tableView.cellForRow(at: indexPath)
      as? OnboardingAnswerTableCell {
      newCell.setIsSelected(isSelected: true)
    }

    // 이벤트 방출
    selection.onNext((question, optionIndex))
    // 질문에 대해서 첫 선택일 경우에만 다음 질문 열기
    if isFirstSelection {
      revealPreviousSection()
    }
  }

  public func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    40
  }

  public func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    UIView()
  }

  public func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    60
  }
}
