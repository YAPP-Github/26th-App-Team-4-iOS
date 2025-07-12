//
//  OnboardingStep.swift
//  Presentation
//
//  Created by JDeoks on 7/12/25.
//


public enum OnboardingStep: CaseIterable {
  
  case basic
  case experience
  case adaptation
  case goal

  public var guideText: String {
    switch self {
    case .basic:
      return "기본 체력에 관한 질문이에요."
    case .experience:
      return "운동 경험에 관한 질문이에요."
    case .adaptation:
      return "러닝 적응력에 관한 질문이에요."
    case .goal:
      return "러닝을 오래 이어가려면 필요한 첫 질문이에요."
    }
  }

  public var questions: [OnboardingQuestion] {
    switch self {
    case .basic:
      return [
        .basicReaction,
        .basicDirection,
        .basicFollow,
        .basicBalance
      ]
    case .experience:
      return [
        .expFrequency,
        .expExperience
      ]
    case .adaptation:
      return [
        .adapt5Min,
        .adaptSpeed
      ]
    case .goal:
      return [
        .goalSelection
      ]
    }
  }
}

public enum OnboardingQuestion: CaseIterable {
  case basicReaction
  case basicDirection
  case basicFollow
  case basicBalance

  case expFrequency
  case expExperience

  case adapt5Min
  case adaptSpeed

  case goalSelection

  public var title: String {
    switch self {
    case .basicReaction:
      return "예기치 못한 상황에서 어떻게 반응하시나요?"
    case .basicDirection:
      return "걷는 중 몸의 방향을 바꿀 때 어떤 편인가요?"
    case .basicFollow:
      return "동작을 따라 할 때 나는 어떤 것 같나요?"
    case .basicBalance:
      return "발로 서서 균형을 잡는 건 어떤가요?"
    case .expFrequency:
      return "요즘 운동을 얼마나 하시나요?"
    case .expExperience:
      return "러닝을 해본 경험이 있나요?"
    case .adapt5Min:
      return "5분 동안 달린다면 어떨 것 같으신가요?"
    case .adaptSpeed:
      return "달릴 때 속도를 어떻게 조절하시나요?"
    case .goalSelection:
      return "어떤 목표로 시작해볼까요?"
    }
  }
  
  public var iconText: [String] {
    switch self {
    case .basicReaction:
      return ["⚡", "😐", "🐢"]
    case .basicDirection:
      return ["🌀", "😶", "⛔"]
    case .basicFollow:
      return ["🎯‍‍", "😅", "❌"]
    case .basicBalance:
      return ["🧘", "😵", "🤕"]
    case .expFrequency:
      return ["🏋️", "🏃", "😴"]
    case .expExperience:
      return ["🏃", "✨", "🐌"]
    case .adapt5Min:
      return ["💪", "🤔", "😫"]
    case .adaptSpeed:
      return ["🎵", "🌊", "❓"]
    case .goalSelection:
      return ["🔥", "💓", "🔋", "🥇"]
    }
  }

  public var options: [String] {
    switch self {
    case .basicReaction:
      return ["민첩하게", "보통", "느리게"]
    case .basicDirection:
      return ["유연함", "조금 굳은", "둔한"]
    case .basicFollow:
      return ["쉽게 따라해요", "헷갈려요", "잘 안 맞아요"]
    case .basicBalance:
      return ["쉬워요", "흔들려요", "못해요"]
    case .expFrequency:
      return ["거의 매일", "주 1–2회 정도", "안 해요"]
    case .expExperience:
      return ["많아요", "종종 있어요", "거의 없어요"]
    case .adapt5Min:
      return ["달릴 수 있어요", "모르겠어요", "못해요"]
    case .adaptSpeed:
      return ["일정하게", "왔다갔다", "모르겠어요"]
    case .goalSelection:
      return [
        "다이어트를 위해 뛰어볼래요",
        "건강 관리를 위해 뛰어볼래요",
        "체력 증진을 위해 뛰어볼래요",
        "대회 준비를 위해 뛰어볼래요"
      ]
    }
  }
}