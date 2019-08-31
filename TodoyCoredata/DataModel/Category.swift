//
//  Category.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 28/08/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    //Relation 1 to many(forward relation)
    let items = List<Item>()
    
}
