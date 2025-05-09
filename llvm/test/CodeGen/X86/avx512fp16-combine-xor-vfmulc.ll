; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512fp16,avx512vl --fp-contract=fast --enable-unsafe-fp-math | FileCheck %s

define dso_local <32 x half> @test1(<32 x half> %lhs.coerce.conj, <32 x half> %rhs.coerce) local_unnamed_addr #0 {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfcmulcph %zmm0, %zmm1, %zmm2
; CHECK-NEXT:    vmovaps %zmm2, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <32 x half> %lhs.coerce.conj to <16 x i32>
  %xor.i.i = xor <16 x i32> %0, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %1 = bitcast <16 x i32> %xor.i.i to <16 x float>
  %2 = bitcast <32 x half> %rhs.coerce to <16 x float>
  %3 = tail call fast <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float> %1, <16 x float> %2, <16 x float> zeroinitializer, i16 -1, i32 4) #2
  %4 = bitcast <16 x float> %3 to <32 x half>
  ret <32 x half> %4
}

; Function Attrs: nounwind readnone uwtable
define dso_local <16 x half> @test2(<16 x half> %lhs.coerce.conj, <16 x half> %rhs.coerce) local_unnamed_addr #0 {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfcmulcph %ymm0, %ymm1, %ymm2
; CHECK-NEXT:    vmovaps %ymm2, %ymm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <16 x half> %lhs.coerce.conj to <8 x i32>
  %xor.i.i = xor <8 x i32> %0, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %1 = bitcast <8 x i32> %xor.i.i to <8 x float>
  %2 = bitcast <16 x half> %rhs.coerce to <8 x float>
  %3 = tail call fast <8 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.256(<8 x float> %1, <8 x float> %2, <8 x float> zeroinitializer, i8 -1) #2
  %4 = bitcast <8 x float> %3 to <16 x half>
  ret <16 x half> %4
}

define dso_local <8 x half> @test3(<8 x half> %lhs.coerce.conj, <8 x half> %rhs.coerce) local_unnamed_addr #0 {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfcmulcph %xmm0, %xmm1, %xmm2
; CHECK-NEXT:    vmovaps %xmm2, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <8 x half> %lhs.coerce.conj to <4 x i32>
  %xor.i.i = xor <4 x i32> %0, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %1 = bitcast <4 x i32> %xor.i.i to <4 x float>
  %2 = bitcast <8 x half> %rhs.coerce to <4 x float>
  %3 = tail call fast <4 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.128(<4 x float> %1, <4 x float> %2, <4 x float> zeroinitializer, i8 -1) #2
  %4 = bitcast <4 x float> %3 to <8 x half>
  ret <8 x half> %4
}

define dso_local <8 x half> @test4(<8 x half> %lhs.coerce.conj, <8 x half> %rhs.coerce) local_unnamed_addr #0 {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmulcph %xmm0, %xmm1, %xmm2
; CHECK-NEXT:    vmovaps %xmm2, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <8 x half> %lhs.coerce.conj to <4 x i32>
  %xor.i.i = xor <4 x i32> %0, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %1 = bitcast <4 x i32> %xor.i.i to <4 x float>
  %2 = bitcast <8 x half> %rhs.coerce to <4 x float>
  %3 = tail call fast <4 x float> @llvm.x86.avx512fp16.mask.vfcmul.cph.128(<4 x float> %1, <4 x float> %2, <4 x float> zeroinitializer, i8 -1) #2
  %4 = bitcast <4 x float> %3 to <8 x half>
  ret <8 x half> %4
}

define dso_local <32 x half> @test5(<32 x half> noundef %a, <32 x half> noundef %b) local_unnamed_addr #0 {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpbroadcastw {{.*#+}} zmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxorq %zmm2, %zmm1, %zmm2
; CHECK-NEXT:    vfmulcph %zmm2, %zmm0, %zmm1
; CHECK-NEXT:    vmovaps %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %fneg = fneg <32 x half> %b
  %0 = bitcast <32 x half> %a to <16 x float>
  %1 = bitcast <32 x half> %fneg to <16 x float>
  %2 = tail call <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float> %0, <16 x float> %1, <16 x float> zeroinitializer, i16 -1, i32 4)
  %3 = bitcast <16 x float> %2 to <32 x half>
  ret <32 x half> %3
}

define dso_local <32 x half> @test6(<16 x i32> %a, <16 x float> %b) local_unnamed_addr #0 {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vbroadcastss {{.*#+}} zmm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vfcmulcph %zmm0, %zmm1, %zmm3
; CHECK-NEXT:    vfcmaddcph %zmm0, %zmm2, %zmm3
; CHECK-NEXT:    vaddph %zmm1, %zmm3, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = xor <16 x i32> %a, splat (i32 -2147483648)
  %1 = bitcast <16 x i32> %0 to <16 x float>
  %2 = tail call <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float> splat (float 1.000000e+00), <16 x float> %1, <16 x float> zeroinitializer, i16 -1, i32 4)
  %3 = bitcast <16 x float> %2 to <32 x half>
  %4 = tail call <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float> %1, <16 x float> %b, <16 x float> zeroinitializer, i16 -1, i32 4)
  %5 = bitcast <16 x float> %4 to <32 x half>
  %6 = fadd <32 x half> %3, %5
  %7 = bitcast <16 x float> %b to <32 x half>
  %8 = fadd <32 x half> %6, %7
  ret <32 x half> %8
}

declare <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float>, <16 x float>, <16 x float>, i16, i32 immarg)
declare <8 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.256(<8 x float>, <8 x float>, <8 x float>, i8)
declare <4 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.128(<4 x float>, <4 x float>, <4 x float>, i8)
declare <4 x float> @llvm.x86.avx512fp16.mask.vfcmul.cph.128(<4 x float>, <4 x float>, <4 x float>, i8)
