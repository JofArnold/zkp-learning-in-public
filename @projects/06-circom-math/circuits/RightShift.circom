pragma circom 2.0.0;

template RightShift() {
    signal input in;
    signal output out1;
    signal output out2;
    signal output out3;
    signal shift1;
    signal shift2;
    signal shift3;
    shift1 <-- in >> 8;
    shift2 <-- shift1 >> 4 >> 4;
    shift3 <-- shift2 >> 4 >> 4;
    out1 <== shift1;
    out2 <== shift2;
    out3 <== shift3;
}

component main {public [in]} = RightShift();
