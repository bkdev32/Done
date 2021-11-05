//
//  DataModel.swift
//  Done
//
//  Created by Burhan Kaynak on 28/01/2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
