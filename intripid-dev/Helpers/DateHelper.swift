//
//  DateHelper.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/4/19.
//  Copyright © 2019 zona. All rights reserved.
//
import Foundation

extension NSDate {
  
  func formatDate() -> String {
    //    let dateFormatterGet = DateFormatter()
    //    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MM/dd/yyyy"
    
    //    print(dateFormatterPrint.string(from: self as Date))
    return dateFormatterPrint.string(from: self as Date)
    
  }
}


extension Date {
  static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = fromDate
    
    while date <= toDate {
      dates.append(date)
      guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
      date = newDate
    }
    return dates
  }
}

