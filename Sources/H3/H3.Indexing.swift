import CH3

public func latLngToCell(latitude: Double, longitude: Double, resolution: Int)
    throws -> UInt64
{
    var coords = CH3.LatLng(
        lat: CH3.degsToRads(latitude), lng: CH3.degsToRads(longitude))
    var index: H3Index = 0
    let error = CH3.latLngToCell(&coords, Int32(resolution), &index)
    try H3ErrorCode.throwOnError(error)

    return index
}

public func cellToLatLng(cell: UInt64) throws -> (
    latitude: Double, longitude: Double
) {
    var coords = LatLng(lat: 0, lng: 0)
    let error = CH3.cellToLatLng(cell, &coords)
    try H3ErrorCode.throwOnError(error)

    let latDeg = CH3.radsToDegs(coords.lat)
    let lngDeg = CH3.radsToDegs(coords.lng)
    return (latitude: latDeg, longitude: lngDeg)
}

public func cellToBoundary(cell: UInt64) throws -> [CH3.LatLng] {
    var boundary = CellBoundary()
    let err = CH3.cellToBoundary(cell, &boundary)
    try H3ErrorCode.throwOnError(err)

    let coords = withUnsafeBytes(of: &boundary.verts) { raw -> [LatLng] in
        let buffer = raw.bindMemory(to: LatLng.self)
        var result = Array(buffer.prefix(Int(boundary.numVerts)))
        for (i, latlng) in result.enumerated() {
            result[i].lat = radsToDegs(latlng.lat)
            result[i].lng = radsToDegs(latlng.lng)
        }
        return result
    }

    return coords
}
