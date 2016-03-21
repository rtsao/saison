'use strict';

var nearley = require('nearley');
var grammar = require('./grammar');

module.exports = function parse(src) {
  var parser = new nearley.Parser(grammar.ParserRules, grammar.ParserStart)
    .feed(src);
  
  if (parser.results.length) {
    return parser.results[0];
  } else {
    throw Error('Parse failed.');
  }
}
