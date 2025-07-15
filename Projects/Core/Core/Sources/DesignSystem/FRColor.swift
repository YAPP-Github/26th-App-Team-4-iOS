//
//  FRColor.swift
//  Core
//
//  Created by JDeoks on 7/12/25.
//


import UIKit

public enum FRColor {
  public enum Base {
    
  }
  
  public enum Color {
    
    public enum Brand {
      
      public enum Primary {
        
      }
    }
  }
  
  public enum FG {
    
    public enum Text {
      public static let primary: UIColor = UIColor(hex: "#1A1C20")
      public static let secondary: UIColor = UIColor(hex: "#555D6D")
      
      public enum Interactive {
        public static let inverse: UIColor = UIColor(hex: "#FFFFFF")
      }
    }
    
    public enum Icon {
      public static let primary: UIColor = UIColor(hex: "#1A1C20")
      
      public enum interactive {
        public static let primary: UIColor = UIColor(hex: "#FF6600")
      }
    }
  }
  
  public enum BG {
    public static let primary: UIColor = UIColor(hex: "#FFFFFF")

    
    public enum interactive {
      public static let primary: UIColor = UIColor(hex: "#FF6600")
      public static let secondary: UIColor = UIColor(hex: "#2A3038")
    }

  }
}
