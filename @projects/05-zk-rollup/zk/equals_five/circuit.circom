pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template EqualsFive() {
    signal input a;
    signal input b;
    signal output out;
    signal enabled;
    enabled <== 1;

    component eq = ForceEqualIfEnabled();
    eq.enabled <== enabled;
    eq.in[0] <== a + b;
    eq.in[1] <== 5;
    out <== 1;
}

component main = EqualsFive();
