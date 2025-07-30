import CH3
import CoreLocation

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

public func cellToLatLng(cell: UInt64) throws -> CLLocationCoordinate2D {
    var coords = LatLng(lat: 0, lng: 0)
    let error = CH3.cellToLatLng(cell, &coords)
    try H3ErrorCode.throwOnError(error)

    return radsToDegs(latLng: coords)
}

public func cellToBoundary(cell: UInt64) throws -> [CLLocationCoordinate2D] {
    var boundary = CellBoundary()
    let err = CH3.cellToBoundary(cell, &boundary)
    try H3ErrorCode.throwOnError(err)

    let coords = withUnsafeBytes(of: &boundary.verts) { raw -> [LatLng] in
        let buffer = raw.bindMemory(to: LatLng.self)
        var result = Array(buffer.prefix(Int(boundary.numVerts)))
        return result
    }

    return coords.map({c in radsToDegs(latLng: c)})
}
