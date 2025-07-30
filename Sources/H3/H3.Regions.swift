import CH3
import CoreLocation

public func polygonToCells(
    boundary: [CLLocationCoordinate2D],
    resolution: Int,
    flags: UInt32
) throws -> [UInt64] {
    let latLngs = boundary.map {
        LatLng(
            lat: CH3.degsToRads($0.latitude), lng: CH3.degsToRads($0.longitude))
    }

    var maxSize: Int64 = 0
    let sizeErr = latLngs.withUnsafeBufferPointer { buf in
        CH3.maxPolygonToCellsSizeSimple(
            buf.baseAddress, Int32(buf.count), Int32(resolution), flags,
            &maxSize)
    }
    precondition(sizeErr == 0, "maxPolygonToCellsSize failed")

    var output = [UInt64](repeating: 0, count: Int(maxSize))
    var outSize: Int32 = Int32(maxSize)

    let err = output.withUnsafeMutableBufferPointer { outBuf in
        latLngs.withUnsafeBufferPointer { vertBuf in
            CH3.polyfillWithFlags(
                vertBuf.baseAddress,
                Int32(latLngs.count),
                Int32(resolution),
                flags,
                outBuf.baseAddress,
                &outSize
            )
        }
    }
    try H3ErrorCode.throwOnError(err)

    return Array(output.prefix(Int(outSize)))
}

public func maxPolygonToCellsSize(
    boundary: [CLLocationCoordinate2D],
    resolution: Int,
    flags: UInt32
) throws -> Int {
    let latLngs = boundary.map {
        LatLng(
            lat: CH3.degsToRads($0.latitude), lng: CH3.degsToRads($0.longitude))
    }

    var size: Int64 = 0
    let err = latLngs.withUnsafeBufferPointer { buf in
        CH3.maxPolygonToCellsSizeSimple(
            buf.baseAddress, Int32(buf.count), Int32(resolution), flags, &size)
    }
    precondition(
        err == 0 && size >= 0, "maxPolygonToCellsSize failed with error \(err)")

    return Int(size)
}

public func polygonToCellsExperimental(
    boundary: [CLLocationCoordinate2D],
    resolution: Int,
    containmentMode: PolygonContainment = .center
) throws -> [UInt64] {
    let latLngs = boundary.map {
        LatLng(
            lat: CH3.degsToRads($0.latitude), lng: CH3.degsToRads($0.longitude))
    }

    // Get max size first
    var maxSize: Int64 = 0
    let sizeErr = latLngs.withUnsafeBufferPointer { buf in
        CH3.maxPolygonToCellsSizeSimple(
            buf.baseAddress, Int32(buf.count), Int32(resolution),
            containmentMode.rawValue, &maxSize)
    }
    precondition(sizeErr == 0, "maxPolygonToCellsSize failed")

    var output = [UInt64](repeating: 0, count: Int(maxSize))

    let err = output.withUnsafeMutableBufferPointer { outBuf in
        latLngs.withUnsafeBufferPointer { buf in
            CH3.polygonToCellsExperimentalSimple(
                buf.baseAddress,
                Int32(buf.count),
                Int32(resolution),
                containmentMode.rawValue,
                maxSize,
                outBuf.baseAddress
            )
        }
    }
    precondition(err == 0, "polygonToCellsExperimental failed")

    return output.filter { $0 != 0 }
}

public func cellsToLinkedMultiPolygon(cells: [UInt64]) throws -> [LatLng] {
    var polygon = LinkedGeoPolygon()
    let err = cells.withUnsafeBufferPointer {
        CH3.cellsToLinkedMultiPolygon($0.baseAddress, Int32($0.count), &polygon)
    }
    precondition(err == 0, "cellsToLinkedMultiPolygon failed")

    defer {
        _ = withUnsafeMutablePointer(to: &polygon) {
            CH3.destroyPolygonWrapper($0)
        }
    }

    guard let loop = polygon.first else { return [] }

    var result: [LatLng] = []
    var vertex = loop.pointee.first
    while let v = vertex {
        result.append(v.pointee.vertex)
        vertex = v.pointee.next
    }

    return result
}

public enum PolygonContainment: UInt32 {
    case center = 0
    case full = 1
    case overlapping = 2
    case overlappingBoundingBox = 3
}

public struct PolygonLoop {
    public var coordinates: [LatLng]
}

public struct MultiPolygon {
    public var loops: [PolygonLoop]
}
