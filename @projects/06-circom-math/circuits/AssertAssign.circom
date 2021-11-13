pragma circom 2.0.0;

template AssertAssign() {
    signal input in;
    signal output out;
    out <== in;
}

component main {public [in]} = AssertAssign();
