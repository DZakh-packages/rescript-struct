// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

var Test = /* @__PURE__ */Caml_exceptions.create("TestUtils.Test");

function raiseTestException() {
  throw {
        RE_EXN_ID: Test,
        Error: new Error()
      };
}

function assertThrowsTestException(t, fn, message, param) {
  try {
    fn(undefined);
    return t.fail("Didn't throw");
  }
  catch (raw_exn){
    var exn = Caml_js_exceptions.internalToOCamlException(raw_exn);
    if (exn.RE_EXN_ID === Test) {
      t.pass(message !== undefined ? Caml_option.valFromOption(message) : undefined);
      return ;
    } else {
      return t.fail("Thrown another exception");
    }
  }
}

function cleanUpStruct(struct) {
  var $$new = {};
  Object.entries(struct).forEach(function (param) {
        var value = param[1];
        var key = param[0];
        switch (key) {
          case "i" :
          case "pb" :
          case "sb" :
              return ;
          default:
            if (typeof value === "object" && value !== null) {
              $$new[key] = cleanUpStruct(value);
            } else {
              $$new[key] = value;
            }
            return ;
        }
      });
  return $$new;
}

function unsafeAssertEqualStructs(t, s1, s2, message, param) {
  t.deepEqual(cleanUpStruct(s1), cleanUpStruct(s2), message !== undefined ? Caml_option.valFromOption(message) : undefined);
}

var assertEqualStructs = unsafeAssertEqualStructs;

export {
  Test ,
  raiseTestException ,
  assertThrowsTestException ,
  cleanUpStruct ,
  unsafeAssertEqualStructs ,
  assertEqualStructs ,
}
/* No side effect */
