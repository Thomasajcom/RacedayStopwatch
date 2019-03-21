//
//  ThemeProtocol.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 08/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeProtocol {
    var foregroundColor      : UIColor { get }
    var backgroundColor      : UIColor { get }
    var barColor             : UIColor { get }
    var tintColor            : UIColor { get }
    var mainFontColor        : UIColor { get }
    var secondaryFontColor   : UIColor { get }
    var highlightColor       : UIColor { get }
    var highlightFontColor   : UIColor { get }
    var confirmColor         : UIColor { get }
    var deleteColor          : UIColor { get }
}
