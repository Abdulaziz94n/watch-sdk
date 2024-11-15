//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleBleAddress: BleReadable {
    public var mAddress = ""

    public override func decode() {
        super.decode()
        mAddress = String(format: "%02X:%02X:%02X:%02X:%02X:%02X",
            readUInt8(), readUInt8(), readUInt8(), readUInt8(), readUInt8(), readUInt8())
    }
}
