export const convertMovesArrayToBinaryString = (moves: number[]) =>
  moves.map((m) => m.toString(2).padStart(4, "0")).join("");

export const convertBinaryStringToInt = (binaryString: string) =>
  parseInt(binaryString, 2);
