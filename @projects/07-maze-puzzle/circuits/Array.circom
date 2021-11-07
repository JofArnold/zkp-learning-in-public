pragma circom 2.0.0;

template Array() {
    signal input in[5];
    signal output out[5];
    for (var i = 0; i<5; i++) {
        out[i] <-- in[i] + 3;
    }
}

component main {public [in]} = Array();
