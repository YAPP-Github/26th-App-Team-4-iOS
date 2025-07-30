//
//  FRColor.swift
//  Core
//
//  Created by dong eun shin on 7/30/25.
//

import UIKit

public enum FRColor {

  public enum Base {
    public static let black = UIColor.baseBlack
    public static let white = UIColor.baseWhite
    public static let gray = UIColor.baseBlack
  }

  // MARK: - Brand Colors
  
  public enum Color {
    public enum Brand {
      public enum Primary {
        public static let _100: UIColor = .redOrange100
        public static let _200: UIColor = .redOrange200
        public static let _300: UIColor = .redOrange300
        public static let _400: UIColor = .redOrange400
        public static let _500: UIColor = .redOrange500
        public static let _600: UIColor = .redOrange600
        public static let _700: UIColor = .redOrange700
        public static let _800: UIColor = .redOrange800
        public static let _900: UIColor = .redOrange900
        public static let _1000: UIColor = .redOrange1000
      }
    }
  }

  // MARK: - Foreground Colors

  public enum Fg {
    public enum Text {
      public static let primary: UIColor = .gray1000
      public enum Interactive {
        public static let primary: UIColor = .redOrange600
        public static let primaryHoverd: UIColor = .redOrange700
        public static let secondary: UIColor = .gray800
        public static let secondaryHoverd: UIColor = .gray900
        public static let selected: UIColor = .redOrange600
        public static let inverse: UIColor = .baseWhite
        public static let primaryPressed: UIColor = .redOrange800
        public static let secondaryPressed: UIColor = .gray1000
      }
      public static let secondary: UIColor = .gray800
      public static let tertiary: UIColor = .gray700
      public static let info: UIColor = .blue700
      public static let infoBold: UIColor = .blue900
      public static let warning: UIColor = .red700
      public static let warningBold: UIColor = .red800
      public static let success: UIColor = .blue700
      public static let successBold: UIColor = .blue800
      public static let disabled: UIColor = .gray600
    }
    public enum Icon {
      public static let primary: UIColor = .gray1000
      public enum Interactive {
        public static let primary: UIColor = .redOrange600
        public static let primaryHoverd: UIColor = .redOrange700
        public static let primaryPressed: UIColor = .redOrange800
        public static let secondary: UIColor = .gray800
        public static let secondaryHoverd: UIColor = .gray900
        public static let secondaryPressed: UIColor = .gray1000
        public static let selected: UIColor = .redOrange600
        public static let inverse: UIColor = .baseWhite
      }
      public static let secondary: UIColor = .gray800
      public static let tertiary: UIColor = .gray700
      public static let info: UIColor = .blue700
      public static let warning: UIColor = .red700
      public static let success: UIColor = .blue700
      public static let disabled: UIColor = .gray600
    }
    public enum Border {
      public static let primary: UIColor = .gray400
      public enum Interactive {
        public static let primary: UIColor = .redOrange600
        public static let primaryHoverd: UIColor = .redOrange700
        public static let primaryPressed: UIColor = .redOrange800
        public static let secondary: UIColor = .gray700
        public static let secondaryHoverd: UIColor = .gray800
        public static let secondaryPressed: UIColor = .gray900
      }
      public static let secondary: UIColor = .gray200
      public static let infoSubtle: UIColor = .blue100
      public static let info: UIColor = .blue800
      public static let warningSubtle: UIColor = .red100
      public static let warning: UIColor = .red800
      public static let successSubtle: UIColor = .blue100
      public static let success: UIColor = .blue800
      public static let disabled: UIColor = .gray500
      public static let tertiary: UIColor = .gray100
    }
    public enum Nuetral {
      public static let gray0: UIColor = .gray0
      public static let gray100: UIColor = .gray100
      public static let gray200: UIColor = .gray200
      public static let gray300: UIColor = .gray300
      public static let gray400: UIColor = .gray400
      public static let gray500: UIColor = .gray500
      public static let gray600: UIColor = .gray600
      public static let gray700: UIColor = .gray700
      public static let gray800: UIColor = .gray800
      public static let gray900: UIColor = .gray900
      public static let gray1000: UIColor = .gray1000
    }
  }

  // MARK: - Background Colors

  public enum Bg {
    public static let primary: UIColor = .baseWhite
    public enum Interactive {
      public static let primary: UIColor = .redOrange600
      public static let primaryHoverd: UIColor = .redOrange700
      public static let secondary: UIColor = .gray900
      public static let secondaryHoverd: UIColor = .gray1000
      public static let selected: UIColor = .redOrange100
      public static let primaryPressed: UIColor = .redOrange800
      public static let secondaryPressed: UIColor = .gray1000
      public static let selectedHovered: UIColor = .redOrange200
      public static let selectedPressed: UIColor = .redOrange300
    }
    public static let secondary: UIColor = .baseGray
    public static let brand: UIColor = .redOrange600
    public static let infoSubtle: UIColor = .blue100
    public static let infoBold: UIColor = .blue800
    public static let warningSubtle: UIColor = .red100
    public static let warningBold: UIColor = .red800
    public static let successSubtle: UIColor = .blue100
    public static let successBold: UIColor = .blue800
    public static let brandSubtle: UIColor = .redOrange100
    public static let disabled: UIColor = .gray400
  }
}
