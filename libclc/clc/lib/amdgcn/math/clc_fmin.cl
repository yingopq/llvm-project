//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clc/clcmacro.h>
#include <clc/internal/clc.h>
#include <clc/relational/clc_isnan.h>

_CLC_DEF _CLC_OVERLOAD float __clc_fmin(float x, float y) {
  // fcanonicalize removes sNaNs and flushes denormals if not enabled. Otherwise
  // fmin instruction flushes the values for comparison, but outputs original
  // denormal
  x = __builtin_canonicalizef(x);
  y = __builtin_canonicalizef(y);
  return __builtin_fminf(x, y);
}
_CLC_BINARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, float, __clc_fmin, float, float)

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

_CLC_DEF _CLC_OVERLOAD double __clc_fmin(double x, double y) {
  x = __builtin_canonicalize(x);
  y = __builtin_canonicalize(y);
  return __builtin_fmin(x, y);
}
_CLC_BINARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, double, __clc_fmin, double,
                      double)

#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

_CLC_DEF _CLC_OVERLOAD half __clc_fmin(half x, half y) {
  if (__clc_isnan(x))
    return y;
  if (__clc_isnan(y))
    return x;
  return (y < x) ? y : x;
}
_CLC_BINARY_VECTORIZE(_CLC_OVERLOAD _CLC_DEF, half, __clc_fmin, half, half)

#endif
