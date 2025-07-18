import UIKit

class HomeViewController: BaseViewController {
  
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
  
  override func initUI() {
    super.initUI()
    view.backgroundColor = .white
    
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
  }
}