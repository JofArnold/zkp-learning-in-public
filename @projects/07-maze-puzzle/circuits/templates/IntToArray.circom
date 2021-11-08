pragma circom 2.0.0;

include "./Fun.circom";

template IntToArray() {
    signal input in;
    signal output out[10];
    for (var i = 0; i < 5; i++) {
        out[i] <-- fun(in[i], 3);
    }
}
