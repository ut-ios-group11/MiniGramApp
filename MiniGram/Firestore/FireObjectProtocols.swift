//
//  FireInitableGeneric.swift
//  MiniGram
//
//  Created by Keegan Black on 2/12/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FireInitable {
    init(doc: DocumentSnapshot)
}
