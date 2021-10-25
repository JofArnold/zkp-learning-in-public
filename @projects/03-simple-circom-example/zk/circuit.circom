template AddsToFive() {
    signal private input a;
    signal private input b;
    signal private input c;
    signal private input d;
    signal private input e;
    signal output f;
    a + b + c + d + e === 5;
    f <== 1;
}

component main = AddsToFive();
