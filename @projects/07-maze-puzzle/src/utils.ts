export const convertMovesArrayToBinaryString = (moves: number[]) =>
  moves.map((m) => m.toString(2).padStart(4, "0")).join("");

export const convertMovesArrayToPaddedBinaryString = (
  moves: number[],
  totalBytes: number
): string => {
  const array = Array(totalBytes).fill("0");
  moves.forEach((m, i) => {
    array[i] = m;
  });
  return array.map((m) => m.toString(2).padStart(4, "0")).join("");
};

export const convertMovesArrayToSignedPaddedBinaryString = (
  moves: number[],
  totalBytes: number
): string => {
  const array = Array(totalBytes).fill("0");
  moves.forEach((m, i) => {
    array[i] = m;
  });
  return array
    .map((m) => {
      let str = Math.abs(m).toString(2);
      if (m < 0) {
        str = "1" + str.padStart(4, "0");
      } else {
        str = str.padStart(5, "0");
      }
      return str;
    })
    .join("");
};

export const convertBinaryStringToInt = (binaryString: string) => {
  const length = binaryString.length;
  const missing = 4 - (length % 4);
  const shouldBe = missing + length;
  const corrected = binaryString.padStart(shouldBe, "0");
  return parseInt(corrected, 2);
};
