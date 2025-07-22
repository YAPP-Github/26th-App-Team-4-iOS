//
//  FirstRunningOnboardingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/20/25.
//

import UIKit
import SnapKit
import Then
import Lottie

class FirstRunningOnboardingViewController: UIViewController {
  // MARK: - UI Elements

  let animationView = LottieAnimationView().then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
    $0.animationSpeed = 1.0
    $0.animation = LottieAnimation.named("file_name")
  }

  let setGoalButton = UIButton().then {
    $0.setTitle("목표 설정하기", for: .normal)
    $0.backgroundColor = .orange
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//    $0.isHidden = true
  }

  let doLaterButton = UIButton().then {
    $0.setTitle("다음에 하기", for: .normal)
    $0.backgroundColor = .clear
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//    $0.isHidden = true
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black

    setupLayout()
    addTargets()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playAnimationAndShowButtons()
  }

  // MARK: - Setup Layout

  private func setupLayout() {
    view.addSubview(animationView)
    view.addSubview(setGoalButton)
    view.addSubview(doLaterButton)

    animationView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(animationView.snp.width)
    }

    setGoalButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(54)
    }

    doLaterButton.snp.makeConstraints { make in
      make.top.equalTo(setGoalButton.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }
  }

  // MARK: - Animation and Button Visibility

  private func playAnimationAndShowButtons() {
    animationView.play { [weak self] finished in
      guard let self = self else { return }
      if finished {
        UIView.animate(withDuration: 0.5) {
          self.setGoalButton.isHidden = false
          self.doLaterButton.isHidden = false
        }
      }
    }
  }

  // MARK: - Button Actions

  private func addTargets() {
    setGoalButton.addTarget(self, action: #selector(setGoalButtonTapped), for: .touchUpInside)
    doLaterButton.addTarget(self, action: #selector(doLaterButtonTapped), for: .touchUpInside)
  }

  @objc private func setGoalButtonTapped() {
    print("목표 설정하기 button tapped!")
  }

  @objc private func doLaterButtonTapped() {
    print("다음에 하기 button tapped!")
  }
}


//import SwiftUI
//
//struct GoalSelectionViewControllerRepresentable: UIViewControllerRepresentable {
//  func makeUIViewController(context: Context) -> FirstRunningOnboardingViewController {
//    // Instantiate your UIKit ViewController
//    return FirstRunningOnboardingViewController()
//  }
//  
//  func updateUIViewController(_ uiViewController: FirstRunningOnboardingViewController, context: Context) {
//    // No updates needed for this simple preview
//  }
//}
//
//struct GoalSelectionViewController_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      GoalSelectionViewControllerRepresentable()
//        .previewDisplayName("Goal Selection Screen - iPhone 15 Pro")
//        .previewDevice("iPhone 15 Pro")
//        .edgesIgnoringSafeArea(.all)
//      GoalSelectionViewControllerRepresentable()
//        .previewDisplayName("Goal Selection Screen - iPhone SE (3rd Gen)")
//        .previewDevice("iPhone SE (3rd generation)")
//        .edgesIgnoringSafeArea(.all)
//        .preferredColorScheme(.dark)
//    }
//  }
//}
