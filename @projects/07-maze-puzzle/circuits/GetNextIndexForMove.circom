pragma circom 2.0.0;

include "./templates/GetNextIndexForMove.circom";

component main {public [from, direction]} = GetNextIndexForMove();
