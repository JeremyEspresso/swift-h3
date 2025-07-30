import CH3

public func areNeighborCells(a: UInt64, b: UInt64) throws -> Bool {
    var isNeighbor: Int32 = 0
    let err = CH3.areNeighborCells(a, b, &isNeighbor)
    try H3ErrorCode.throwOnError(err)

    return isNeighbor != 0
}

public func cellsToDirectedEdge(origin: UInt64, destination: UInt64) throws
    -> UInt64
{
    var edge: UInt64 = 0
    let err = CH3.cellsToDirectedEdge(origin, destination, &edge)
    try H3ErrorCode.throwOnError(err)

    return edge
}

public func isValidDirectedEdge(edge: UInt64) -> Bool {
    return CH3.isValidDirectedEdge(edge) != 0
}

public func getDirectedEdgeOrigin(edge: UInt64) throws -> UInt64 {
    var origin: UInt64 = 0
    let err = CH3.getDirectedEdgeOrigin(edge, &origin)
    try H3ErrorCode.throwOnError(err)

    return origin
}

public func getDirectedEdgeDestination(edge: UInt64) throws -> UInt64 {
    var destination: UInt64 = 0
    let err = CH3.getDirectedEdgeDestination(edge, &destination)
    try H3ErrorCode.throwOnError(err)

    return destination
}

public func directedEdgeToCells(edge: UInt64) throws -> (
    origin: UInt64, destination: UInt64
) {
    var buffer = [UInt64](repeating: 0, count: 2)
    let err = buffer.withUnsafeMutableBufferPointer {
        CH3.directedEdgeToCells(edge, $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return (origin: buffer[0], destination: buffer[1])
}

public func originToDirectedEdges(origin: UInt64) throws -> [UInt64] {
    var edges = [UInt64](repeating: 0, count: 6)
    let err = edges.withUnsafeMutableBufferPointer {
        CH3.originToDirectedEdges(origin, $0.baseAddress)
    }
    try H3ErrorCode.throwOnError(err)

    return edges.filter { $0 != 0 }
}

public func directedEdgeBoundary(edge: UInt64) throws -> [LatLng] {
    var boundary = CellBoundary()
    let err = CH3.directedEdgeToBoundary(edge, &boundary)
    try H3ErrorCode.throwOnError(err)

    let coords = withUnsafeBytes(of: &boundary.verts) { raw -> [LatLng] in
        let buffer = raw.bindMemory(to: LatLng.self)
        return Array(buffer.prefix(Int(boundary.numVerts)))
    }

    return coords
}
