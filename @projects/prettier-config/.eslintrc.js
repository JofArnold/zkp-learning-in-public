module.exports = {
  root: true,
  env: {
    jest: true,
    node: true,
    es6: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:prettier/recommended",
  ],
  plugins: ["prettier"],
  rules: {
    "prettier/prettier": ["error", { singleQuote: false }],
    "@typescript-eslint/no-var-requires": 0,
  },
};
