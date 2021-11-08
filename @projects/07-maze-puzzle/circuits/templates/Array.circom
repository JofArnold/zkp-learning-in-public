pragma circom 2.0.0;

include "./Fun.circom";

template Array() {
    signal input in[5];
    signal output out[5];
    var inter;
    for (var i = 0; i < 5; i++) {
        inter = fun(in[i], 3);
        out[i] <-- inter;
    }
}
