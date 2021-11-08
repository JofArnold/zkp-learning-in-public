pragma circom 2.0.0;

include "./templates/IsMoveAllowed.circom";

component main {public [move]} = IsMoveAllowed();
