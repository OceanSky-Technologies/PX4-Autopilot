// -----------------------------------------------------------------------------
// This file was autogenerated by symforce from template:
//     function/FUNCTION.h.jinja
// Do NOT modify by hand.
// -----------------------------------------------------------------------------

#pragma once

#include <matrix/math.hpp>

namespace sym {

/**
 * This function was autogenerated from a symbolic function. Do not modify by hand.
 *
 * Symbolic function: compute_mag_declination_pred_innov_var_and_h
 *
 * Args:
 *     state: Matrix24_1
 *     P: Matrix24_24
 *     R: Scalar
 *     epsilon: Scalar
 *
 * Outputs:
 *     pred: Scalar
 *     innov_var: Scalar
 *     H: Matrix24_1
 */
template <typename Scalar>
void ComputeMagDeclinationPredInnovVarAndH(const matrix::Matrix<Scalar, 24, 1>& state,
                                           const matrix::Matrix<Scalar, 24, 24>& P, const Scalar R,
                                           const Scalar epsilon, Scalar* const pred = nullptr,
                                           Scalar* const innov_var = nullptr,
                                           matrix::Matrix<Scalar, 24, 1>* const H = nullptr) {
  // Total ops: 22

  // Input arrays

  // Intermediate terms (4)
  const Scalar _tmp0 =
      epsilon * ((((state(16, 0)) > 0) - ((state(16, 0)) < 0)) + Scalar(0.5)) + state(16, 0);
  const Scalar _tmp1 =
      Scalar(1.0) / (std::pow(_tmp0, Scalar(2)) + std::pow(state(17, 0), Scalar(2)));
  const Scalar _tmp2 = _tmp1 * state(17, 0);
  const Scalar _tmp3 = _tmp0 * _tmp1;

  // Output terms (3)
  if (pred != nullptr) {
    Scalar& _pred = (*pred);

    _pred = std::atan2(state(17, 0), _tmp0);
  }

  if (innov_var != nullptr) {
    Scalar& _innov_var = (*innov_var);

    _innov_var = R - _tmp2 * (-P(16, 16) * _tmp2 + P(17, 16) * _tmp3) +
                 _tmp3 * (-P(16, 17) * _tmp2 + P(17, 17) * _tmp3);
  }

  if (H != nullptr) {
    matrix::Matrix<Scalar, 24, 1>& _h = (*H);

    _h.setZero();

    _h(16, 0) = -_tmp2;
    _h(17, 0) = _tmp3;
  }
}  // NOLINT(readability/fn_size)

// NOLINTNEXTLINE(readability/fn_size)
}  // namespace sym
