//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <mutex>

// template <class Mutex> class unique_lock;

// bool owns_lock() const;

#include <cassert>
#include <mutex>

#include "test_macros.h"
#include "../types.h"

MyMutex m;

int main(int, char**) {
  std::unique_lock<MyMutex> lk0;
  assert(lk0.owns_lock() == false);
  std::unique_lock<MyMutex> lk1(m);
  assert(lk1.owns_lock() == true);
  lk1.unlock();
  assert(lk1.owns_lock() == false);

  return 0;
}
