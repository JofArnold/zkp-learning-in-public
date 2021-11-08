pragma circom 2.0.0;

template IntToArray() {
    signal input in;
    signal output out[10];
    for (var i = 0; i<5; i++) {
        out[i] <-- in[i] + 3;
    }
}
