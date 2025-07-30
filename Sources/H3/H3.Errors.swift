import CH3

public enum H3ErrorCode: Error {
    case Failed
    case Domain
    case LatLngDomain
    case ResDomain
    case CellInvalid
    case DirEdgeInvalid
    case UndirEdgeInvalid
    case VertexInvalid
    case Pentagon
    case DuplicateInput
    case NotNeighbors
    case ResMismatch
    case MemoryAlloc
    case MemoryBounds
    case OptionInvalid

    // Additional error when size is invalid
    case SizeInvalid

    static func fromH3(_ code: UInt32) -> Error {
        switch code {
        case E_SUCCESS.rawValue:
            fatalError("Cannot create error from success code")
        case E_FAILED.rawValue:
            return H3ErrorCode.Failed
        case E_DOMAIN.rawValue:
            return H3ErrorCode.Domain
        case E_LATLNG_DOMAIN.rawValue:
            return H3ErrorCode.LatLngDomain
        case E_RES_DOMAIN.rawValue:
            return H3ErrorCode.ResDomain
        case E_CELL_INVALID.rawValue:
            return H3ErrorCode.CellInvalid
        case E_DIR_EDGE_INVALID.rawValue:
            return H3ErrorCode.DirEdgeInvalid
        case E_UNDIR_EDGE_INVALID.rawValue:
            return H3ErrorCode.UndirEdgeInvalid
        case E_VERTEX_INVALID.rawValue:
            return H3ErrorCode.VertexInvalid
        case E_PENTAGON.rawValue:
            return H3ErrorCode.Pentagon
        case E_DUPLICATE_INPUT.rawValue:
            return H3ErrorCode.DuplicateInput
        case E_NOT_NEIGHBORS.rawValue:
            return H3ErrorCode.NotNeighbors
        case E_RES_MISMATCH.rawValue:
            return H3ErrorCode.ResMismatch
        case E_MEMORY_ALLOC.rawValue:
            return H3ErrorCode.MemoryAlloc
        case E_MEMORY_BOUNDS.rawValue:
            return H3ErrorCode.MemoryBounds
        case E_OPTION_INVALID.rawValue:
            return H3ErrorCode.OptionInvalid
        default:
            fatalError("Unhandled error code: \(code)")
        }
    }

    static func throwOnError(_ code: UInt32) throws {
        if code != E_SUCCESS.rawValue {
            throw H3ErrorCode.fromH3(code)
        }
    }
}

extension H3ErrorCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Failed:
            return
                "The operation failed but a more specific error is not available"
        case .Domain:
            return
                "Argument was outside of acceptable range (when a more specific error code is not available)"
        case .LatLngDomain:
            return
                "Latitude or longitude arguments were outside of acceptable range"
        case .ResDomain:
            return "Resolution argument was outside of acceptable range"
        case .CellInvalid: return "`H3Index` cell argument was not valid"
        case .DirEdgeInvalid:
            return "`H3Index` directed edge argument was not valid"
        case .UndirEdgeInvalid:
            return "`H3Index` undirected edge argument was not valid"
        case .VertexInvalid: return "`H3Index` vertex argument was not valid"
        case .Pentagon:
            return
                "Pentagon distortion was encountered which the algorithm could not handle it"
        case .DuplicateInput:
            return
                "Duplicate input was encountered in the arguments and the algorithm could not handle it"
        case .NotNeighbors: return "`H3Index` cell arguments were not neighbors"
        case .ResMismatch:
            return "`H3Index` cell arguments had incompatible resolutions"
        case .MemoryAlloc: return "Necessary memory allocation failed"
        case .MemoryBounds:
            return "Bounds of provided memory were not large enough"
        case .OptionInvalid: return "Mode or flags argument was not valid."
        default:
            fatalError("No description available for unrecognized error")
        }
    }
}
