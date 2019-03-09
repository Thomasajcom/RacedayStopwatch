//
//  DefaultTheme.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation
import UIKit

class LightTheme: ThemeProtocol {
    var backgroundColor: UIColor = UIColor(named: "BackgroundColor")!
    var tintColor: UIColor = UIColor(named: "TintColor")!
    var barColor: UIColor = UIColor(named: "BarColor")!
    var barTint: UIColor = UIColor(named: "BarTint")!
    var cellBackground: UIColor = UIColor(named: "CellBackground")!
    var cellTint: UIColor = UIColor(named: "CellTint")!
    var mainFontColor: UIColor = UIColor(named: "MainFontColor")!
    var secondaryFontColor: UIColor = UIColor(named: "SecondaryFontColor")!
    var highlightColor: UIColor = UIColor(named: "HighlightColor")!
    var highlightFontColor: UIColor = UIColor(named: "HighlightFontCOlor")!
    var confirmColor: UIColor = UIColor(named: "ConfirmColor")!
    var deleteColor: UIColor = UIColor(named: "DeleteColor")!
}
