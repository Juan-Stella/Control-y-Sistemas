/* =====================================================================
 * iir_filter_fixed.c  —  Filtros IIR Q15, puntos 6 y 7
 *
 * Esta version NO usa iir_get_sos() ni iir_st.
 * Lee NUM y DEN de fdacoefs.h directamente.
 *
 * Compilar:
 *   mex iir_wrapper_fixed.c iir_filter_fixed.c iir_filter.c
 * ================================================================== */

#include "mex.h"
#include "tmwtypes.h"

/* fdacoefs.h solo puede incluirse en UN .c (iir_filter.c lo incluye).
 * Declaramos NUM/DEN como extern para evitar multiple definition. */
#define MWSPT_NSEC 33
extern const real64_T NUM[MWSPT_NSEC][3];
extern const real64_T DEN[MWSPT_NSEC][3];

/* GAINS y STAGES */
#define GAINS  (MWSPT_NSEC/2 + MWSPT_NSEC%2)
#define STAGES (GAINS - 1)

/* ── Q15 ─────────────────────────────────────────────────────────── */
#define Q15        32767
#define Q15_SHIFT  15

static int16_T f2q(float x) {
    int32_T v = (int32_T)(x * Q15);
    if (v >  Q15) v =  Q15;
    if (v < -Q15) v = -Q15;
    return (int16_T)v;
}
static int16_T mulq(int16_T a, int16_T b) {
    return (int16_T)(((int32_T)a * (int32_T)b) >> Q15_SHIFT);
}
static int16_T satq(int32_T v) {
    if (v >  Q15) return  Q15;
    if (v < -Q15) return -Q15;
    return (int16_T)v;
}

/* Lee ganancia de sección k (filas pares de NUM) */
static float get_gain(int k) { return (float)NUM[k*2][0]; }

/* Lee coeficiente de numerador b[j] de sección k (filas impares) */
static float get_b(int k, int j) { return (float)NUM[k*2+1][j]; }

/* Lee coeficiente de denominador a[j] de sección k (filas impares) */
static float get_a(int k, int j) { return (float)DEN[k*2+1][j]; }

/* ================================================================== */
/*  PUNTO 6 — 2do orden, Direct Form I, Q15                           */
/* ================================================================== */
void iir_2nd_df1_fixed(float *input, float *output)
{
    static int16_T x[3] = {0};
    static int16_T y[3] = {0};
    int32_T acc;

    x[0] = f2q((*input) * get_gain(0));

    acc  = (int32_T)mulq(f2q(get_b(0,0)), x[0]);
    acc += (int32_T)mulq(f2q(get_b(0,1)), x[1]);
    acc += (int32_T)mulq(f2q(get_b(0,2)), x[2]);
    acc -= (int32_T)mulq(f2q(get_a(0,1)), y[1]);
    acc -= (int32_T)mulq(f2q(get_a(0,2)), y[2]);

    y[0] = satq(acc);
    y[2]=y[1]; y[1]=y[0];
    x[2]=x[1]; x[1]=x[0];

    *output = (float)y[0] / Q15 * get_gain(1);
}

/* ================================================================== */
/*  PUNTO 6 — 2do orden, Direct Form II, Q15                          */
/* ================================================================== */
void iir_2nd_df2_fixed(float *input, float *output)
{
    static int16_T delay[3] = {0};
    int32_T acc;

    int16_T in_q15 = f2q((*input) * get_gain(0));

    acc  = (int32_T)in_q15;
    acc -= (int32_T)mulq(f2q(get_a(0,1)), delay[1]);
    acc -= (int32_T)mulq(f2q(get_a(0,2)), delay[2]);
    delay[0] = satq(acc);

    acc  = (int32_T)mulq(f2q(get_b(0,0)), delay[0]);
    acc += (int32_T)mulq(f2q(get_b(0,1)), delay[1]);
    acc += (int32_T)mulq(f2q(get_b(0,2)), delay[2]);

    delay[2]=delay[1]; delay[1]=delay[0];
    *output = (float)satq(acc) / Q15 * get_gain(1);
}

/* ================================================================== */
/*  PUNTO 7 — Orden N, Direct Form I, Q15                             */
/* ================================================================== */
void iir_nth_df1_fixed(float *input, float *output)
{
    static int16_T x[STAGES][3] = {0};
    static int16_T y[STAGES][3] = {0};
    int32_T acc;
    unsigned int s;
    float acc_f = *input;

    for (s = 0; s < STAGES; s++) {
        x[s][0] = f2q(acc_f * get_gain(s));

        acc  = (int32_T)mulq(f2q(get_b(s,0)), x[s][0]);
        acc += (int32_T)mulq(f2q(get_b(s,1)), x[s][1]);
        acc += (int32_T)mulq(f2q(get_b(s,2)), x[s][2]);
        acc -= (int32_T)mulq(f2q(get_a(s,1)), y[s][1]);
        acc -= (int32_T)mulq(f2q(get_a(s,2)), y[s][2]);

        y[s][0] = satq(acc);
        y[s][2]=y[s][1]; y[s][1]=y[s][0];
        x[s][2]=x[s][1]; x[s][1]=x[s][0];

        acc_f = (float)y[s][0] / Q15;
    }
    *output = acc_f * get_gain(STAGES);
}

/* ================================================================== */
/*  PUNTO 7 — Orden N, Direct Form II, Q15                            */
/* ================================================================== */
void iir_nth_df2_fixed(float *input, float *output)
{
    static int16_T delay[STAGES][3] = {0};
    int32_T acc;
    int16_T in_q15;
    unsigned int s;
    float acc_f = *input;

    for (s = 0; s < STAGES; s++) {
        in_q15 = f2q(acc_f * get_gain(s));

        acc  = (int32_T)in_q15;
        acc -= (int32_T)mulq(f2q(get_a(s,1)), delay[s][1]);
        acc -= (int32_T)mulq(f2q(get_a(s,2)), delay[s][2]);
        delay[s][0] = satq(acc);

        acc  = (int32_T)mulq(f2q(get_b(s,0)), delay[s][0]);
        acc += (int32_T)mulq(f2q(get_b(s,1)), delay[s][1]);
        acc += (int32_T)mulq(f2q(get_b(s,2)), delay[s][2]);

        delay[s][2]=delay[s][1]; delay[s][1]=delay[s][0];
        acc_f = (float)satq(acc) / Q15;
    }
    *output = acc_f * get_gain(STAGES);
}