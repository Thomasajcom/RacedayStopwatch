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
    var foregroundColor: UIColor        = .gray
    var backgroundColor: UIColor        = .darkGray
    var barColor: UIColor               = .gray
    var tintColor: UIColor              = .black
    var mainFontColor: UIColor          = UIColor(named: "MainFontColor")!
    var secondaryFontColor: UIColor     = UIColor(named: "SecondaryFontColor")!
    var highlightColor: UIColor         = UIColor(named: "HighlightColor")!
    var highlightFontColor: UIColor     = UIColor(named: "HighlightFontColor")!
    var confirmColor: UIColor           = UIColor(named: "ConfirmColor")!
    var deleteColor: UIColor            = UIColor(named: "DeleteColor")!
}
