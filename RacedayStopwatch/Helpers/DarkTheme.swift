//
//  DarkTheme.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation
import UIKit

class DarkTheme: ThemeProtocol {
    var foregroundColor: UIColor        = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    var backgroundColor: UIColor        = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    var barColor: UIColor               = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    var tintColor: UIColor              = UIColor(named: "ConfirmColor")!
    var mainFontColor: UIColor          = .white
    var secondaryFontColor: UIColor     = UIColor(named: "SecondaryFontColor")!
    var highlightColor: UIColor         = UIColor(named: "HighlightColor")!
    var highlightFontColor: UIColor     = UIColor(named: "HighlightFontColor")!
    var confirmColor: UIColor           = UIColor(named: "ConfirmColor")!
    var deleteColor: UIColor            = UIColor(named: "DeleteColor")!
}
