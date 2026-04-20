/* =====================================================================
 * iir_filter_fixed.h
 * ================================================================== */

#ifndef IIR_FILTER_FIXED_H
#define IIR_FILTER_FIXED_H

#include "iir_filter.h"   /* reutiliza iir_st e iir_get_sos() */

/* Punto 6 — 2do orden, Q15 */
void iir_2nd_df1_fixed(float *input, float *output);
void iir_2nd_df2_fixed(float *input, float *output);

/* Punto 7 — Orden N, Q15 */
void iir_nth_df1_fixed(float *input, float *output);
void iir_nth_df2_fixed(float *input, float *output);

#endif
