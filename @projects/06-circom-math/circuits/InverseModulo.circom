pragma circom 2.0.0;

template InverseModulo() {
    signal input in1;
    signal input in2;
    signal input in3;
    signal output out;
    signal foo;
    signal bar;
    foo <-- in1 / in2;
    bar <-- foo * in3;
    out <== bar;
}

component main {public [in1,in2, in3]} = InverseModulo();
