//
//  FileManager+Ext.swift
//  HotProspects
//
//  Created by Fabio Tiberio on 21/03/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
