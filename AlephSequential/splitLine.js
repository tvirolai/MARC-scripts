module.exports = function splitLine(line) {
  return {
      "id": line.substr(0,9),
      "tag": line.substr(10,3),
      "content": line.substr(18)
    };
}
