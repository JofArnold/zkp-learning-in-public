pragma circom 2.0.0;

template Assert() {
    signal input in;
    in === 29;
}

component main = Assert();
