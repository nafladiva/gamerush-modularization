//
//  DateUtil.swift
//  Common
//
//  Created by Nafla Diva Syafia on 30/11/24.
//

import Foundation

public class DateUtil {
    public static func formatReleaseDate(responseDate: String, fromFormat: String, toFormat: String) -> String {
        let dateFormatterResponse = DateFormatter()
        dateFormatterResponse.dateFormat = fromFormat
        let dateFormatterView = DateFormatter()
        dateFormatterView.dateFormat = toFormat
        let formatted = dateFormatterResponse.date(from: responseDate)
        let formattedReleased = "Released on \(dateFormatterView.string(from: formatted!))"
        
        return formattedReleased
    }
}
