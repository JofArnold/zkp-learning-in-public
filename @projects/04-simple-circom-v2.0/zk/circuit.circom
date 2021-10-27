pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";


template EqualsFive() {
    signal input a;
    signal input b;
    signal output out;
    signal sum;
    signal target;
    sum <== a + b;
    target <== 5;
    component eq = IsEqual();
    sum ==> eq.in[0];
    target ==> eq.in[1];
    out <== eq.out;
}

component main = EqualsFive();
