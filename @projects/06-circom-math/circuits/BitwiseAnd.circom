pragma circom 2.0.0;

template BitwiseAnd() {
    signal input in1;
    signal input in2;
    signal output out;
    signal tmp1;
    signal tmp2;
    tmp1 <-- in1 & in2;
    tmp2 <-- tmp1 * 1;
    out <== tmp2;
}

component main {public [in1, in2]} = BitwiseAnd();
