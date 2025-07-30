import CH3

public func degsToRads(degrees: Double) -> Double {
    return CH3.degsToRads(degrees)
}

public func radsToDegs(radians: Double) -> Double {
    return CH3.radsToDegs(radians)
}

public func getHexagonAreaAvgKm2(res: Int32) throws -> Double {
    var area: Double = 0
    let err = CH3.getHexagonAreaAvgKm2(res, &area)
    try H3ErrorCode.throwOnError(err)

    return area
}

public func getHexagonAreaAvgM2(res: Int32) throws -> Double {
    var area: Double = 0
    let err = CH3.getHexagonAreaAvgM2(res, &area)
    try H3ErrorCode.throwOnError(err)

    return area
}

public func cellAreaRads2(cell: UInt64) throws -> Double {
    var area: Double = 0
    let err = CH3.cellAreaRads2(cell, &area)
    try H3ErrorCode.throwOnError(err)

    return area
}

public func cellAreaKm2(cell: UInt64) throws -> Double {
    var area: Double = 0
    let err = CH3.cellAreaKm2(cell, &area)
    try H3ErrorCode.throwOnError(err)

    return area
}

public func cellAreaM2(cell: UInt64) throws -> Double {
    var area: Double = 0
    let err = CH3.cellAreaM2(cell, &area)
    try H3ErrorCode.throwOnError(err)

    return area
}

public func getHexagonEdgeLengthAvgKm(res: Int32) throws -> Double {
    var length: Double = 0
    let err = CH3.getHexagonEdgeLengthAvgKm(res, &length)
    try H3ErrorCode.throwOnError(err)

    return length
}

public func getHexagonEdgeLengthAvgM(res: Int32) throws -> Double {
    var length: Double = 0
    let err = CH3.getHexagonEdgeLengthAvgM(res, &length)
    try H3ErrorCode.throwOnError(err)

    return length
}

public func edgeLengthKm(edge: UInt64) throws -> Double {
    var length: Double = 0
    let err = CH3.edgeLengthKm(edge, &length)
    try H3ErrorCode.throwOnError(err)

    return length
}

public func edgeLengthM(edge: UInt64) throws -> Double {
    var length: Double = 0
    let err = CH3.edgeLengthM(edge, &length)
    try H3ErrorCode.throwOnError(err)

    return length
}

public func edgeLengthRads(edge: UInt64) throws -> Double {
    var length: Double = 0
    let err = CH3.edgeLengthRads(edge, &length)
    try H3ErrorCode.throwOnError(err)

    return length
}

public func getNumCells(res: Int32) throws -> Int64 {
    var count: Int64 = 0
    let err = CH3.getNumCells(res, &count)
    try H3ErrorCode.throwOnError(err)

    return count
}

public func getRes0Cells() throws -> [UInt64] {
    let count = try getRes0CellCount()
    var output = [UInt64](repeating: 0, count: count)
    let err = output.withUnsafeMutableBufferPointer {
        CH3.getRes0Cells($0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func getRes0CellCount() throws -> Int {
    return Int(CH3.res0CellCount())
}

public func getPentagons(res: Int32) throws -> [UInt64] {
    var output = [UInt64](repeating: 0, count: try pentagonCount())
    let err = output.withUnsafeMutableBufferPointer {
        CH3.getPentagons(res, $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func pentagonCount() throws -> Int {
    return Int(CH3.pentagonCount())
}

public func greatCircleDistanceKm(a: LatLng, b: LatLng) throws -> Double {
    withUnsafePointer(to: a) { pa in
        withUnsafePointer(to: b) { pb in
            CH3.greatCircleDistanceKm(pa, pb)
        }
    }
}

public func greatCircleDistanceM(a: LatLng, b: LatLng) throws -> Double {
    withUnsafePointer(to: a) { pa in
        withUnsafePointer(to: b) { pb in
            CH3.greatCircleDistanceM(pa, pb)
        }
    }
}

public func greatCircleDistanceRads(a: LatLng, b: LatLng) throws -> Double {
    withUnsafePointer(to: a) { pa in
        withUnsafePointer(to: b) { pb in
            CH3.greatCircleDistanceRads(pa, pb)
        }
    }
}

public func describeH3Error(err: Int32) throws -> String {
    let error: H3Error = UInt32(err)

    guard let cStr = CH3.describeH3Error(error) else {
        return "Unknown error"
    }

    return String(cString: cStr)
}
