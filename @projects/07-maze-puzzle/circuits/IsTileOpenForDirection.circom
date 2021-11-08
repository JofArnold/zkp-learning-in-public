pragma circom 2.0.0;

include "./templates/IsTileOpenForDirection.circom";

component main {public [tileCode, direction]} = IsTileOpenForDirection();
