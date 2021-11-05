//
//  ItemData.swift
//  Done
//
//  Created by Burhan Kaynak on 28/01/2021.
//

import Foundation
import RealmSwift

class Item: EmbeddedObject {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
