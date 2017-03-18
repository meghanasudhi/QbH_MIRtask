/*
 *  dpcore.c
 *  Core of dynamic programming/DTW calculation
 * 2003-04-02 dpwe@ee.columbia.edu
 * $Header: /Users/dpwe/projects/dtw/RCS/dpcore.c,v 1.4 2009/07/27 22:54:53 dpwe Exp $
 * % Copyright (c) 2003-05 Dan Ellis <dpwe@ee.columbia.edu>
 * % released under GPL - see file COPYRIGHT
 */

#include    <stdio.h>
#include    <math.h>
#include    <ctype.h>
#include    "mex.h"

/* #define DEBUG */

/* #define INF HUGE_VAL */
#define INF DBL_MAX

void
        mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int 	i,j;
    long   	pvl, pvb[16];
    
#ifdef DEBUG
mexPrintf("similvectors: Got %d lhs args and %d rhs args.\n",
        nlhs, nrhs);
for (i=0;i<nrhs;i++) {
    mexPrintf("RHArg #%d is size %d x %d\n",
            (long)i, mxGetM(prhs[i]), mxGetN(prhs[i]));
}
for (i=0;i<nlhs;i++)
    if (plhs[i]) {
    mexPrintf("LHArg #%d is size %d x %d\n",
            (long)i, mxGetM(plhs[i]), mxGetN(plhs[i]));
    }
#endif /* DEBUG */

if (nrhs < 1){
    mexPrintf("Computes the moving distance between two F0 vectors\n");
    return;
}

if (nlhs > 0){
    mxArray  *MMatrix;
    int rows1, rows2, cols1, cols2, i, j;
    double *pM, *pV1, *pV2;
    double d1, d2, d3, v;

    
    rows1 = mxGetM(prhs[0]);
    rows2 = mxGetM(prhs[1]);
    cols1 = mxGetN(prhs[0]);
    cols2 = mxGetN(prhs[1]);
    pV1 = mxGetPr(prhs[0]);
    pV2 = mxGetPr(prhs[1]);
    
    MMatrix = mxCreateDoubleMatrix(cols1, cols2, mxREAL);
    pM = mxGetPr(MMatrix);
    plhs[0] = MMatrix;
    
    for (i = 0; i < cols1; ++i) {
        for (j = 0; j < cols2; ++j) {
            d1 = pV1[i];
            d2 = pV2[j];
            v=d1-d2;
            pM[i + j*cols1] = v*v;
        }
    }
}

#ifdef DEBUG
mexPrintf("similvectors: returning...\n");
#endif /* DEBUG */
}

