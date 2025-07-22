#ifndef H3API_EXT_H
#define H3API_EXT_H

#include <stdint.h>
#include "h3api.h"

H3Error polyfillWithFlags(const LatLng* verts, int numVerts, int res, uint32_t flags, H3Index* out, int* outSize);
H3Error maxPolygonToCellsSizeSimple(const LatLng* verts, int numVerts, int res, uint32_t flags, int64_t* out);
H3Error polygonToCellsExperimentalSimple(
    const LatLng* verts,
    int numVerts,
    int res,
    uint32_t flags,
    int64_t size,
    H3Index* out
);
H3Error maxPolygonToCellsSizeExperimentalSimple(const LatLng* verts, int numVerts, int res, uint32_t flags, int64_t* out);
int cellsToPolygonFlat(
    const H3Index* cells,
    int numCells,
    LatLng* coords,
    int maxCoords,
    int* actualCount
);
H3Error destroyPolygonWrapper(LinkedGeoPolygon* polygon);

#endif
