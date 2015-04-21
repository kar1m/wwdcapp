//
//  ArrayExtension.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 21/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import Foundation

extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}