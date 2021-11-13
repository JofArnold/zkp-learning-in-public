pragma circom 2.0.0;

template AssertAssignPrivate() {
    signal input in;
    signal output out;
    out <== in;
}

component main = AssertAssignPrivate();
