import CH3

public func gridDistance(origin: UInt64, destination: UInt64) throws -> Int64 {
    var distance: Int64 = 0
    let err = CH3.gridDistance(origin, destination, &distance)

    try H3ErrorCode.throwOnError(err)
    return distance
}

public func gridRing(origin: UInt64, distance: Int) throws -> [UInt64] {
    guard distance > 0 else { return [origin] }

    let count = 6 * distance
    var output = [UInt64](repeating: 0, count: count)
    let err = output.withUnsafeMutableBufferPointer {
        CH3.gridRing(origin, Int32(distance), $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func gridRingUnsafe(origin: UInt64, distance: Int) throws -> [UInt64] {
    guard distance > 0 else { return [origin] }

    let count = 6 * distance
    var output = [UInt64](repeating: 0, count: count)
    let err = output.withUnsafeMutableBufferPointer {
        CH3.gridRingUnsafe(origin, Int32(distance), $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func maxGridRingSize(distance: Int) throws -> Int64 {
    var size: Int64 = 0
    let err = CH3.maxGridRingSize(Int32(distance), &size)
    try H3ErrorCode.throwOnError(err)

    return size
}

public func gridDisk(origin: UInt64, distance: Int) throws -> [UInt64] {
    let count = Int(try maxGridDiskSize(distance: distance))
    var output = [UInt64](repeating: 0, count: count)

    let err = output.withUnsafeMutableBufferPointer {
        CH3.gridDisk(origin, Int32(distance), $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func maxGridDiskSize(distance: Int) throws -> Int64 {
    var size: Int64 = 0
    let err = CH3.maxGridDiskSize(Int32(distance), &size)
    try H3ErrorCode.throwOnError(err)

    return size
}

public func gridDiskDistances(origin: UInt64, distance: Int) throws
    -> [[UInt64]]
{
    let count = Int(try maxGridDiskSize(distance: distance))

    var indexes = [UInt64](repeating: 0, count: count)
    var distances = [Int32](repeating: -1, count: count)

    let err = indexes.withUnsafeMutableBufferPointer { idxBuf in
        distances.withUnsafeMutableBufferPointer { distBuf in
            CH3.gridDiskDistances(
                origin, Int32(distance), idxBuf.baseAddress, distBuf.baseAddress
            )
        }
    }

    try H3ErrorCode.throwOnError(err)

    var rings = Array(repeating: [UInt64](), count: distance + 1)
    for i in 0..<count {
        let dist = Int(distances[i])
        if dist >= 0 && dist <= distance {
            rings[dist].append(indexes[i])
        }
    }
    return rings
}

public func gridDiskUnsafe(origin: UInt64, distance: Int) throws -> [UInt64] {
    let count = Int(try maxGridDiskSize(distance: distance))
    var output = [UInt64](repeating: 0, count: count)

    let err = output.withUnsafeMutableBufferPointer {
        CH3.gridDiskUnsafe(origin, Int32(distance), $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func gridPathCells(start: UInt64, end: UInt64) throws -> [UInt64] {
    let distance = try gridPathCellsSize(start: start, end: end)
    let count = distance + 1
    var output = [UInt64](repeating: 0, count: count)

    let err = output.withUnsafeMutableBufferPointer {
        CH3.gridPathCells(start, end, $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func gridPathCellsSize(start: UInt64, end: UInt64) throws -> Int {
    var size: Int64 = 0
    let err = CH3.gridPathCellsSize(start, end, &size)
    try H3ErrorCode.throwOnError(err)
    if size < 0 {
        throw H3ErrorCode.SizeInvalid
    }
    return Int(size)
}

public func cellToLocalIJ(origin: UInt64, target: UInt64, mode: UInt32 = 0)
    throws -> CoordIJ
{
    var ij = CH3.CoordIJ(i: 0, j: 0)
    let err = withUnsafeMutablePointer(to: &ij) {
        CH3.cellToLocalIj(origin, target, mode, $0)
    }
    try H3ErrorCode.throwOnError(err)
    return CoordIJ(i: ij.i, j: ij.j)
}

public func localIJToCell(origin: UInt64, ij: CoordIJ, mode: UInt32 = 0) throws
    -> UInt64
{
    var result: UInt64 = 0
    var coord = CH3.CoordIJ(i: ij.i, j: ij.j)
    let err = withUnsafeMutablePointer(to: &coord) {
        CH3.localIjToCell(origin, $0, mode, &result)
    }
    try H3ErrorCode.throwOnError(err)
    return result
}

public struct CoordIJ {
    public var i: Int32
    public var j: Int32
}
