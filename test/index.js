'use strict';

var fs = require('fs');
var path = require('path');
var test = require('tape');
var parser = require('../');

var testFiles = fs.readdirSync('test/fixtures');

var fixtureRegex = new RegExp('.src$');
var matchesFixture = fixtureRegex.test.bind(fixtureRegex);

var tests = testFiles
  .filter(matchesFixture)
  .map(function toName(file) {
    return path.basename(file, '.src');
  });

tests.forEach(testFromName);

function testFromName(name) {
  test('test ' + name, function (t) {
    var fixtures = getFixtures(name);
    var actual = parser(fixtures.src);
    t.deepEqual(actual, fixtures.ast, 'AST should match expected');
    t.end();
  });
}

function getFixtures(name) {
  return {
    src: fs.readFileSync('test/fixtures/' + name + '.src', 'utf8'),
    ast: require('./fixtures/' + name + '.ast.json')
  };
}
