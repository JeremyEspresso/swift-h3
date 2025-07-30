import CH3

public func cellToVertex(cell: UInt64, vertexNum: Int) throws -> UInt64 {
    var vertex: UInt64 = 0
    let err = CH3.cellToVertex(cell, Int32(vertexNum), &vertex)
    try H3ErrorCode.throwOnError(err)

    return vertex
}

public func cellToVertices(cell: UInt64) throws -> [UInt64] {
    var output = [UInt64](repeating: 0, count: 6)
    let err = output.withUnsafeMutableBufferPointer {
        CH3.cellToVertexes(cell, $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return output.filter { $0 != 0 }
}

public func vertexToLatLng(vertex: UInt64) throws -> LatLng {
    var coord = LatLng(lat: 0, lng: 0)
    let err = CH3.vertexToLatLng(vertex, &coord)
    try H3ErrorCode.throwOnError(err)

    return coord
}

public func isValidVertex(vertex: UInt64) throws -> Bool {
    return CH3.isValidVertex(vertex) != 0
}
