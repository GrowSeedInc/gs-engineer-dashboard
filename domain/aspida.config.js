/** @type {import('openapi2aspida').OpenAPIConfig} */
module.exports = {
  input: "api",
  openapi: {
    inputFile: "generated/openapi.bundled.yaml",
  },
  outputEachDir: false,
};
