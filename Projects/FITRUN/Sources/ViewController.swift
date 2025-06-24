//
//  ViewController.swift
//  Dummy
//
//  Created by JDeoks on 6/14/25.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Hello ViewController!")
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .blue
    
    let label = UILabel().then {
      $0.text = "Hello, World!"
      $0.textColor = .white
      $0.textAlignment = .center
      $0.font = UIFont.systemFont(ofSize: 24)
    }
    
    self.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

