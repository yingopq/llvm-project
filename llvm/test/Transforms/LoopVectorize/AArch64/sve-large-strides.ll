; RUN: opt -mtriple aarch64-linux-gnu -mattr=+sve -passes=loop-vectorize,dce,instcombine -S \
; RUN:   -prefer-predicate-over-epilogue=scalar-epilogue <%s | FileCheck %s

define void @stride7_i32(ptr noalias nocapture %dst, i64 %n) #0 {
; CHECK-LABEL: @stride7_i32(
; CHECK:      vector.body
; CHECK:        %[[VEC_IND:.*]] = phi <vscale x 4 x i64> [ %{{.*}}, %vector.ph ], [ %{{.*}}, %vector.body ]
; CHECK-NEXT:   %[[PTR_INDICES:.*]] = mul nuw nsw <vscale x 4 x i64> %[[VEC_IND]], splat (i64 7)
; CHECK-NEXT:   %[[PTRS:.*]] = getelementptr inbounds i32, ptr %dst, <vscale x 4 x i64> %[[PTR_INDICES]]
; CHECK-NEXT:   %[[GLOAD:.*]] = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32.nxv4p0(<vscale x 4 x ptr> %[[PTRS]]
; CHECK-NEXT:   %[[VALS:.*]] = add nsw <vscale x 4 x i32> %[[GLOAD]],
; CHECK-NEXT:   call void @llvm.masked.scatter.nxv4i32.nxv4p0(<vscale x 4 x i32> %[[VALS]], <vscale x 4 x ptr> %[[PTRS]]
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.05 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i64 %i.05, 7
  %arrayidx = getelementptr inbounds i32, ptr %dst, i64 %mul
  %0 = load i32, ptr %arrayidx, align 4
  %add = add nsw i32 %0, 3
  store i32 %add, ptr %arrayidx, align 4
  %inc = add nuw nsw i64 %i.05, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !0

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

define void @stride7_f64(ptr noalias nocapture %dst, i64 %n) #0 {
; CHECK-LABEL: @stride7_f64(
; CHECK:      vector.body
; CHECK:        %[[VEC_IND:.*]] = phi <vscale x 2 x i64> [ %{{.*}}, %vector.ph ], [ %{{.*}}, %vector.body ]
; CHECK-NEXT:   %[[PTR_INDICES:.*]] = mul nuw nsw <vscale x 2 x i64> %[[VEC_IND]], splat (i64 7)
; CHECK-NEXT:   %[[PTRS:.*]] = getelementptr inbounds double, ptr %dst, <vscale x 2 x i64> %[[PTR_INDICES]]
; CHECK-NEXT:   %[[GLOAD:.*]] = call <vscale x 2 x double> @llvm.masked.gather.nxv2f64.nxv2p0(<vscale x 2 x ptr> %[[PTRS]],
; CHECK-NEXT:   %[[VALS:.*]] = fadd <vscale x 2 x double> %[[GLOAD]],
; CHECK-NEXT:  call void @llvm.masked.scatter.nxv2f64.nxv2p0(<vscale x 2 x double> %[[VALS]], <vscale x 2 x ptr> %[[PTRS]],
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.05 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i64 %i.05, 7
  %arrayidx = getelementptr inbounds double, ptr %dst, i64 %mul
  %0 = load double, ptr %arrayidx, align 8
  %add = fadd double %0, 1.000000e+00
  store double %add, ptr %arrayidx, align 8
  %inc = add nuw nsw i64 %i.05, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !6

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}


define void @cond_stride7_f64(ptr noalias nocapture %dst, ptr noalias nocapture readonly %cond, i64 %n) #0 {
; CHECK-LABEL: @cond_stride7_f64(
; CHECK:      vector.body
; CHECK:        %[[MASK:.*]] = icmp ne <vscale x 2 x i64>
; CHECK:        %[[PTRS:.*]] = getelementptr inbounds double, ptr %dst, <vscale x 2 x i64> %{{.*}}
; CHECK-NEXT:   %[[GLOAD:.*]] = call <vscale x 2 x double> @llvm.masked.gather.nxv2f64.nxv2p0(<vscale x 2 x ptr> %[[PTRS]], i32 8, <vscale x 2 x i1> %[[MASK]]
; CHECK-NEXT:   %[[VALS:.*]] = fadd <vscale x 2 x double> %[[GLOAD]],
; CHECK-NEXT:  call void @llvm.masked.scatter.nxv2f64.nxv2p0(<vscale x 2 x double> %[[VALS]], <vscale x 2 x ptr> %[[PTRS]], i32 8, <vscale x 2 x i1> %[[MASK]])
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.inc
  %i.07 = phi i64 [ %inc, %for.inc ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i64, ptr %cond, i64 %i.07
  %0 = load i64, ptr %arrayidx, align 8
  %tobool.not = icmp eq i64 %0, 0
  br i1 %tobool.not, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %mul = mul nsw i64 %i.07, 7
  %arrayidx1 = getelementptr inbounds double, ptr %dst, i64 %mul
  %1 = load double, ptr %arrayidx1, align 8
  %add = fadd double %1, 1.000000e+00
  store double %add, ptr %arrayidx1, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %inc = add nuw nsw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !6

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

attributes #0 = { vscale_range(1, 16) }
!0 = distinct !{!0, !1, !2, !3, !4, !5}
!1 = !{!"llvm.loop.mustprogress"}
!2 = !{!"llvm.loop.vectorize.width", i32 4}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{!"llvm.loop.interleave.count", i32 1}
!5 = !{!"llvm.loop.vectorize.enable", i1 true}
!6 = distinct !{!6, !1, !7, !3, !4, !5}
!7 = !{!"llvm.loop.vectorize.width", i32 2}
