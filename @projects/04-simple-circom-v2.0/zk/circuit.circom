pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";


template EqualsFive() {
    signal input a;
    signal input b;
    signal output sum;
    component eq = IsEqual();
    a ==> eq.in[0];
    b ==> eq.in[1];
    sum <== eq.out;
}

component main = EqualsFive();
