pragma circom 2.0.0;

include "./templates/IsTileOpenForSide.circom";

component main {public [tileCode, direction]} = IsTileOpenForSide();
