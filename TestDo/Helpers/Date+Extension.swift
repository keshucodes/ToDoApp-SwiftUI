//
//  Date+Extension.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import Foundation

extension Date {
    func formatToDayAndMonth() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "d MMM"
          return dateFormatter.string(from: self)
      }
}
