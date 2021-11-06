pragma circom 2.0.0;

template BitwiseAnd() {
    signal input in1;
    signal input in2;
    signal output out;
    signal foo;
    signal bar;
    foo <-- in1 & in2;
    bar <-- foo * 1;
    out <== bar;
}

component main {public [in1, in2]} = BitwiseAnd();
