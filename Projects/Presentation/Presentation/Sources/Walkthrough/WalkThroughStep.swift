//
//  WalkThroughStep.swift
//  Presentation
//
//  Created by JDeoks on 7/9/25.
//

import UIKit

public enum WalkThroughStep: Int, CaseIterable {
  case step1
  case step2
  case step3

  var title: String {
    switch self {
    case .step1:
      return "나에게 꼭 맞는 러닝 플랜"
    case .step2:
      return "오늘도, 나만의 속도로"
    case .step3:
      return "매일 쌓이는 나만의 성장기록"
    }
  }

  var description: String {
    switch self {
    case .step1:
      return "처음 시작하는 러닝, 나의 체력에 맞춘\n루틴으로 가볍게 시작하세요."
    case .step2:
      return "언제든지 원하는 시간과 장소에서\n당신의 속도로 꾸준히 달릴 수 있게 도와드릴게요."
    case .step3:
      return "러닝 기록을 숫자가 아닌 변화로 보여드려요.\n나의 성장을 한눈에 확인하세요."
    }
  }
  
  var image: UIImage? {
    return nil
  }

  var buttonTitle: String {
    switch self {
    case .step1, .step2:
      return "다음"
    case .step3:
      return "시작하기"
    }
  }
}
