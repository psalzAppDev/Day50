//
//  Helper.swift
//  Day50
//
//  Created by Peter Salz on 29.03.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import Foundation

class Helper
{
    static func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
}
