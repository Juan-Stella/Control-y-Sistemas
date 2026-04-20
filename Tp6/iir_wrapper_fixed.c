/* =====================================================================
 * iir_wrapper_fixed.c
 *
 * Interfaz MEX para verificar las funciones Q15 desde MATLAB.
 * Seleccionar la función deseada descomentando la línea correspondiente.
 * ================================================================== */

#include "mex.h"
#include "iir_filter_fixed.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    float *input, *output;

    if (nrhs != 1)
        mexErrMsgIdAndTxt("iir_fixed:nrhs", "Se requiere 1 entrada.");
    if (nlhs != 1)
        mexErrMsgIdAndTxt("iir_fixed:nlhs", "Se requiere 1 salida.");
    if (!mxIsSingle(prhs[0]) || mxIsComplex(prhs[0]))
        mexErrMsgIdAndTxt("iir_fixed:tipo", "La entrada debe ser tipo single.");
    if (mxGetN(prhs[0]) != 1)
        mexErrMsgIdAndTxt("iir_fixed:dim", "La entrada debe ser un vector columna.");

    input  = mxGetData(prhs[0]);
    plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[0]),
                                   mxGetDimensions(prhs[0]),
                                   mxSINGLE_CLASS, mxREAL);
    output = mxGetData(plhs[0]);

    /* ── Seleccionar función (descomentar la deseada) ── */

    /* Punto 6 */
    iir_2nd_df1_fixed(input, output);
//  iir_2nd_df2_fixed(input, output);

    /* Punto 7 */
//  iir_nth_df1_fixed(input, output);
//  iir_nth_df2_fixed(input, output);
}
