pragma circom 2.0.0;

template Remainder() {
    signal input in1;
    signal input in2;
    signal input in3;
    signal output out;
    signal tmp1;
    signal tmp2;
    tmp1 <-- in1 % in2;
    tmp2 <-- tmp1 * in3;
    out <== tmp2;
}

component main {public [in1, in2, in3]} = Remainder();
