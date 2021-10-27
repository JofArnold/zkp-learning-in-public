pragma circom 2.0.0;
include "../node_modules/circomlib/circuits/comparators.circom";

template AddsToFive() {
    signal input a;
    signal input b;
    signal input c;
    signal input d;
    signal input e;
    signal out;
    signal sum;
    sum <== a + b + c + d + e;
    component eq = IsEqual();
    eq.in[0] <== sum;
    eq.in[1] <== 5;
    out <== eq.out;
}

component main = AddsToFive();
