// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var S = require("../src/S.bs.js");
var Curry = require("rescript/lib/js/curry.js");
var Benchmark = require("benchmark");

function addWithPrepare(suite, name, fn) {
  return suite.add(name, Curry._1(fn, undefined));
}

function run(suite) {
  suite.on("cycle", (function ($$event) {
            console.log($$event.target.toString());
          })).run();
}

function makeStringStruct() {
  return S.string(undefined);
}

function makeTestObject() {
  return (Object.freeze({
    number: 1,
    negNumber: -1,
    maxNumber: Number.MAX_VALUE,
    string: 'string',
    longString:
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Vivendum intellegat et qui, ei denique consequuntur vix. Semper aeterno percipit ut his, sea ex utinam referrentur repudiandae. No epicuri hendrerit consetetur sit, sit dicta adipiscing ex, in facete detracto deterruisset duo. Quot populo ad qui. Sit fugit nostrum et. Ad per diam dicant interesset, lorem iusto sensibus ut sed. No dicam aperiam vis. Pri posse graeco definitiones cu, id eam populo quaestio adipiscing, usu quod malorum te. Ex nam agam veri, dicunt efficiantur ad qui, ad legere adversarium sit. Commune platonem mel id, brute adipiscing duo an. Vivendum intellegat et qui, ei denique consequuntur vix. Offendit eleifend moderatius ex vix, quem odio mazim et qui, purto expetendis cotidieque quo cu, veri persius vituperata ei nec. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    boolean: true,
    deeplyNested: {
      foo: 'bar',
      num: 1,
      bool: false,
    },
  }));
}

function makeAdvancedObjectStruct() {
  return S.transform(S.object7([
                  "number",
                  S.$$float(undefined)
                ], [
                  "negNumber",
                  S.$$float(undefined)
                ], [
                  "maxNumber",
                  S.$$float(undefined)
                ], [
                  "string",
                  S.string(undefined)
                ], [
                  "longString",
                  S.string(undefined)
                ], [
                  "boolean",
                  S.bool(undefined)
                ], [
                  "deeplyNested",
                  S.object3([
                        "foo",
                        S.string(undefined)
                      ], [
                        "num",
                        S.$$float(undefined)
                      ], [
                        "bool",
                        S.bool(undefined)
                      ])
                ]), (function (param) {
                var match = param[6];
                return {
                        number: param[0],
                        negNumber: param[1],
                        maxNumber: param[2],
                        string: param[3],
                        longString: param[4],
                        boolean: param[5],
                        deeplyNested: {
                          foo: match[0],
                          num: match[1],
                          bool: match[2]
                        }
                      };
              }), (function (object) {
                return [
                        object.number,
                        object.negNumber,
                        object.maxNumber,
                        object.string,
                        object.longString,
                        object.boolean,
                        [
                          object.deeplyNested.foo,
                          object.deeplyNested.num,
                          object.deeplyNested.bool
                        ]
                      ];
              }), undefined);
}

function makeAdvancedStrictObjectStruct(param) {
  return S.$$Object.strict(S.transform(S.object7([
                      "number",
                      S.$$float(undefined)
                    ], [
                      "negNumber",
                      S.$$float(undefined)
                    ], [
                      "maxNumber",
                      S.$$float(undefined)
                    ], [
                      "string",
                      S.string(undefined)
                    ], [
                      "longString",
                      S.string(undefined)
                    ], [
                      "boolean",
                      S.bool(undefined)
                    ], [
                      "deeplyNested",
                      S.$$Object.strict(S.object3([
                                "foo",
                                S.string(undefined)
                              ], [
                                "num",
                                S.$$float(undefined)
                              ], [
                                "bool",
                                S.bool(undefined)
                              ]))
                    ]), (function (param) {
                    var match = param[6];
                    return {
                            number: param[0],
                            negNumber: param[1],
                            maxNumber: param[2],
                            string: param[3],
                            longString: param[4],
                            boolean: param[5],
                            deeplyNested: {
                              foo: match[0],
                              num: match[1],
                              bool: match[2]
                            }
                          };
                  }), (function (object) {
                    return [
                            object.number,
                            object.negNumber,
                            object.maxNumber,
                            object.string,
                            object.longString,
                            object.boolean,
                            [
                              object.deeplyNested.foo,
                              object.deeplyNested.num,
                              object.deeplyNested.bool
                            ]
                          ];
                  }), undefined));
}

function makeAdvancedObjectStructV3() {
  return S.object(function (o) {
              return {
                      number: S.field(o, undefined, S.$$float(undefined)),
                      negNumber: S.field(o, undefined, S.$$float(undefined)),
                      maxNumber: S.field(o, undefined, S.$$float(undefined)),
                      string: S.field(o, undefined, S.string(undefined)),
                      longString: S.field(o, undefined, S.string(undefined)),
                      boolean: S.field(o, undefined, S.bool(undefined)),
                      deeplyNested: S.field(o, undefined, S.object(function (o) {
                                return {
                                        foo: S.field(o, undefined, S.string(undefined)),
                                        num: S.field(o, undefined, S.$$float(undefined)),
                                        bool: S.field(o, undefined, S.bool(undefined))
                                      };
                              }))
                    };
            });
}

function makeAdvancedStrictObjectStructV3() {
  return S.$$Object.strict(S.object(function (o) {
                  return {
                          number: S.field(o, undefined, S.$$float(undefined)),
                          negNumber: S.field(o, undefined, S.$$float(undefined)),
                          maxNumber: S.field(o, undefined, S.$$float(undefined)),
                          string: S.field(o, undefined, S.string(undefined)),
                          longString: S.field(o, undefined, S.string(undefined)),
                          boolean: S.field(o, undefined, S.bool(undefined)),
                          deeplyNested: S.field(o, undefined, S.$$Object.strict(S.object(function (o) {
                                        return {
                                                foo: S.field(o, undefined, S.string(undefined)),
                                                num: S.field(o, undefined, S.$$float(undefined)),
                                                bool: S.field(o, undefined, S.bool(undefined))
                                              };
                                      })))
                        };
                }));
}

run(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(new Benchmark.Suite().add("String struct factory", makeStringStruct), "Parse string", (function (param) {
                                        var struct = makeStringStruct();
                                        return function () {
                                          return S.parseWith("Hello world!", struct);
                                        };
                                      })), "Serialize string", (function (param) {
                                    var struct = makeStringStruct();
                                    return function () {
                                      return S.serializeWith("Hello world!", struct);
                                    };
                                  })).add("Advanced object struct factory", makeAdvancedObjectStruct).add("Advanced object struct factory V3", makeAdvancedObjectStructV3), "Parse advanced object", (function (param) {
                            var struct = makeAdvancedObjectStruct();
                            var data = makeTestObject();
                            return function () {
                              return S.parseWith(data, struct);
                            };
                          })), "Parse advanced object V3", (function (param) {
                        var struct = makeAdvancedObjectStructV3();
                        var data = makeTestObject();
                        return function () {
                          return S.parseWith(data, struct);
                        };
                      })), "Parse advanced strict object", (function (param) {
                    var struct = makeAdvancedStrictObjectStruct(undefined);
                    var data = makeTestObject();
                    return function () {
                      return S.parseWith(data, struct);
                    };
                  })), "Parse advanced strict object V3", (function (param) {
                var struct = makeAdvancedStrictObjectStructV3();
                var data = makeTestObject();
                return function () {
                  return S.parseWith(data, struct);
                };
              })), "Serialize advanced object", (function (param) {
            var struct = makeAdvancedObjectStruct();
            var data = makeTestObject();
            return function () {
              return S.serializeWith(data, struct);
            };
          })));

/*  Not a pure module */
