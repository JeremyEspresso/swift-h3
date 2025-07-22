#include "h3api_ext.h"
#include "h3api.h"
#include "polygon.h"
#include "linkedGeo.h"
#include <string.h>

H3Error polyfillWithFlags(const LatLng* verts, int numVerts, int res, uint32_t flags, H3Index* out, int* outSize) {
    GeoLoop loop = { .numVerts = numVerts, .verts = (LatLng*)verts };
    GeoPolygon polygon = { .geoloop = loop, .numHoles = 0, .holes = NULL };

    int64_t maxSize = 0;
    H3Error sizeErr = maxPolygonToCellsSize(&polygon, res, flags, &maxSize);
    if (sizeErr != 0) return sizeErr;

    if (out == NULL) return 0; // just querying size

    H3Error fillErr = polygonToCells(&polygon, res, flags, out);
    if (fillErr != 0) return fillErr;

    if (outSize) *outSize = (int)maxSize;
    return 0;
}

H3Error maxPolygonToCellsSizeSimple(const LatLng* verts, int numVerts, int res, uint32_t flags, int64_t* out) {
    GeoLoop loop = { .numVerts = numVerts, .verts = (LatLng*)verts };
    GeoPolygon polygon = { .geoloop = loop, .numHoles = 0, .holes = NULL };
    return maxPolygonToCellsSize(&polygon, res, flags, out);
}

H3Error maxPolygonToCellsSizeExperimentalSimple(const LatLng* verts, int numVerts, int res, uint32_t flags, int64_t* out) {
    GeoLoop loop = { .numVerts = numVerts, .verts = (LatLng*)verts };
    GeoPolygon polygon = { .geoloop = loop, .numHoles = 0, .holes = NULL };
    return maxPolygonToCellsSizeExperimental(&polygon, res, flags, out);
}

H3Error polygonToCellsExperimentalSimple(
    const LatLng* verts,
    int numVerts,
    int res,
    uint32_t flags,
    int64_t size,
    H3Index* out
) {
    GeoLoop loop = { .numVerts = numVerts, .verts = (LatLng*)verts };
    GeoPolygon polygon = { .geoloop = loop, .numHoles = 0, .holes = NULL };
    return polygonToCellsExperimental(&polygon, res, flags, size, out);
}

int cellsToPolygonFlat(const H3Index* cells, int numCells, LatLng* coords, int maxCoords, int* actualCount) {
    LinkedGeoPolygon polygon;
    memset(&polygon, 0, sizeof(polygon));

    H3Error err = cellsToLinkedMultiPolygon(cells, numCells, &polygon);
    if (err) return err;

    int count = 0;
    for (LinkedGeoPolygon* poly = &polygon; poly; poly = poly->next) {
        for (LinkedGeoLoop* loop = poly->first; loop; loop = loop->next) {
            for (LinkedLatLng* coord = loop->first; coord; coord = coord->next) {
                if (count >= maxCoords) goto cleanup;
                coords[count++] = coord->vertex;
            }
        }
    }

cleanup:
    destroyLinkedMultiPolygon(&polygon);
    if (actualCount) *actualCount = count;
    return 0;
}

H3Error destroyPolygonWrapper(LinkedGeoPolygon* polygon) {
    destroyLinkedMultiPolygon(polygon);
    return 0;
}



