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
    var backgroundColor: UIColor        = .darkGray
    var tintColor: UIColor              = .black
    var barColor: UIColor               = .black
    var barTint: UIColor                = .black
    var cellBackground: UIColor         = .darkGray
    var cellTint: UIColor               = .black
    var mainFontColor: UIColor          = .blue
    var secondaryFontColor: UIColor     = .yellow
    var highlightColor: UIColor         = .green
    var highlightFontColor: UIColor     = .white
    var confirmColor: UIColor           = UIColor(named: "ConfirmColor")!
    var deleteColor: UIColor            = UIColor(named: "DeleteColor")!
}
