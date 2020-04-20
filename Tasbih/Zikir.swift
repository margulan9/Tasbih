//
//  Zikir.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/17/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class Zikir: Object {
    @objc dynamic var zikirName = ""
    @objc dynamic var zikirArabName = ""
    @objc dynamic var zikirMeaning = ""
    @objc dynamic var zikirTranscript = ""
    @objc dynamic var todayCount = 0
    @objc dynamic var totalCount = 0
}
