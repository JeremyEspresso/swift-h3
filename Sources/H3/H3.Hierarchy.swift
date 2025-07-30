import CH3

public func cellToParent(cell: UInt64, resolution: Int) throws -> UInt64 {
    var parent: UInt64 = 0
    let err = CH3.cellToParent(cell, Int32(resolution), &parent)
    try H3ErrorCode.throwOnError(err)

    return parent
}

public func cellToChildren(cell: UInt64, childResolution: Int) throws
    -> [UInt64]
{
    let count = try cellToChildrenSize(
        cell: cell, childResolution: childResolution)
    var output = [UInt64](repeating: 0, count: Int(count))

    let err = output.withUnsafeMutableBufferPointer {
        CH3.cellToChildren(cell, Int32(childResolution), $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output
}

public func cellToChildrenSize(cell: UInt64, childResolution: Int) throws
    -> Int64
{
    var size: Int64 = 0
    let err = CH3.cellToChildrenSize(cell, Int32(childResolution), &size)
    try H3ErrorCode.throwOnError(err)

    return size
}

public func cellToCenterChild(cell: UInt64, childResolution: Int) throws
    -> UInt64
{
    var result: UInt64 = 0
    let err = CH3.cellToCenterChild(cell, Int32(childResolution), &result)
    try H3ErrorCode.throwOnError(err)

    return result
}

public func cellToChildPos(child: UInt64, parentResolution: Int) throws -> Int64
{
    var pos: Int64 = 0
    let err = CH3.cellToChildPos(child, Int32(parentResolution), &pos)
    try H3ErrorCode.throwOnError(err)

    return pos
}

public func childPosToCell(
    position: Int64, parent: UInt64, childResolution: Int
) throws -> UInt64 {
    var result: UInt64 = 0
    let err = CH3.childPosToCell(
        position, parent, Int32(childResolution), &result)
    try H3ErrorCode.throwOnError(err)

    return result
}

public func compact(cells: [UInt64]) throws -> [UInt64] {
    var compacted = [UInt64](repeating: 0, count: cells.count)

    let err = cells.withUnsafeBufferPointer { inputBuf in
        compacted.withUnsafeMutableBufferPointer { outputBuf in
            CH3.compactCells(
                inputBuf.baseAddress, outputBuf.baseAddress, Int64(cells.count))
        }
    }
    try H3ErrorCode.throwOnError(err)

    return compacted.filter { $0 != 0 }
}

public func uncompact(compacted: [UInt64], resolution: Int) throws -> [UInt64] {
    let maxSize = try uncompactCellsSize(
        compacted: compacted, resolution: resolution)
    var result = [UInt64](repeating: 0, count: maxSize)

    let err = compacted.withUnsafeBufferPointer { inputBuf in
        result.withUnsafeMutableBufferPointer { outputBuf in
            CH3.uncompactCells(
                inputBuf.baseAddress,
                Int64(compacted.count),
                outputBuf.baseAddress,
                Int64(maxSize),
                Int32(resolution)
            )
        }
    }
    try H3ErrorCode.throwOnError(err)

    return result.filter { $0 != 0 }
}

public func uncompactCellsSize(compacted: [UInt64], resolution: Int) throws
    -> Int
{
    var size: Int64 = 0

    let err = compacted.withUnsafeBufferPointer {
        CH3.uncompactCellsSize(
            $0.baseAddress, Int64(compacted.count), Int32(resolution), &size)
    }
    try H3ErrorCode.throwOnError(err)
    if size < 0 {
        throw H3ErrorCode.SizeInvalid
    }

    return Int(size)
}
