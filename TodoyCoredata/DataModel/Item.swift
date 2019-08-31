//
//  Item.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 28/08/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    //'dynamic' key allows Realm to monitor the changes of variables at runtime and store the values in local DB(sqlite) and this keyword belongs to objc api so we used @objc infront of it
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //inverse relation
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
