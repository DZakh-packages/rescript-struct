// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as S$RescriptSchema from "rescript-schema/src/S.bs.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function unsafeGetVariantPayload(variant) {
  return variant._0;
}

var Test = /* @__PURE__ */Caml_exceptions.create("U.Test");

function raiseTestException() {
  throw {
        RE_EXN_ID: Test,
        Error: new Error()
      };
}

function error(param) {
  var tmp;
  switch (param.operation) {
    case "Parse" :
        tmp = S$RescriptSchema.Flag.typeValidation;
        break;
    case "ParseAsync" :
        tmp = S$RescriptSchema.Flag.typeValidation | S$RescriptSchema.Flag.async;
        break;
    case "ReverseConvertToJson" :
        tmp = S$RescriptSchema.Flag.reverse | S$RescriptSchema.Flag.jsonableOutput;
        break;
    case "ReverseConvert" :
        tmp = S$RescriptSchema.Flag.reverse;
        break;
    case "Assert" :
        tmp = S$RescriptSchema.Flag.typeValidation | S$RescriptSchema.Flag.assertOutput;
        break;
    
  }
  return S$RescriptSchema.$$Error.make(param.code, tmp, param.path);
}

function assertThrowsTestException(t, fn, message, param) {
  try {
    fn();
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

function assertRaised(t, cb, errorPayload) {
  var any;
  try {
    any = cb();
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID === S$RescriptSchema.Raised) {
      t.is(S$RescriptSchema.$$Error.message(err._1), S$RescriptSchema.$$Error.message(error(errorPayload)), undefined);
      return ;
    }
    throw err;
  }
  t.fail("Asserted result is not Error. Recieved: " + JSON.stringify(any));
}

async function assertRaisedAsync(t, cb, errorPayload) {
  var any;
  try {
    any = await cb();
  }
  catch (raw_err){
    var err = Caml_js_exceptions.internalToOCamlException(raw_err);
    if (err.RE_EXN_ID === S$RescriptSchema.Raised) {
      t.is(S$RescriptSchema.$$Error.message(err._1), S$RescriptSchema.$$Error.message(error(errorPayload)), undefined);
      return ;
    }
    throw err;
  }
  return t.fail("Asserted result is not Error. Recieved: " + JSON.stringify(any));
}

function getCompiledCodeString(schema, op) {
  return (
            op === "Assert" ? S$RescriptSchema.compile(schema, "Any", "Assert", "Sync", true) : (
                op === "SerializeJson" ? S$RescriptSchema.compile(S$RescriptSchema.reverse(schema), "Any", "Json", "Sync", false) : (
                    op === "Serialize" ? S$RescriptSchema.compile(S$RescriptSchema.reverse(schema), "Any", "Output", "Sync", false) : (
                        S$RescriptSchema.isAsync(schema) ? S$RescriptSchema.compile(schema, "Any", "Output", "Async", true) : S$RescriptSchema.compile(schema, "Any", "Output", "Sync", true)
                      )
                  )
              )
          ).toString();
}

function cleanUpSchema(schema) {
  var $$new = {};
  Object.entries(schema).forEach(function (param) {
        var value = param[1];
        var key = param[0];
        switch (key) {
          case "c" :
          case "definition" :
          case "i" :
              return ;
          default:
            if (typeof value === "function") {
              return ;
            } else {
              if (typeof value === "object" && value !== null) {
                $$new[key] = cleanUpSchema(value);
              } else {
                $$new[key] = value;
              }
              return ;
            }
        }
      });
  return $$new;
}

function unsafeAssertEqualSchemas(t, s1, s2, message) {
  t.deepEqual(cleanUpSchema(s1), cleanUpSchema(s2), message !== undefined ? Caml_option.valFromOption(message) : undefined);
}

function assertCompiledCode(t, schema, op, code, message) {
  t.is(getCompiledCodeString(schema, op), code, message !== undefined ? Caml_option.valFromOption(message) : undefined);
}

function assertCompiledCodeIsNoop(t, schema, op, message) {
  assertCompiledCode(t, schema, op, "function noopOperation(i) {\n  return i;\n}", message);
}

function assertReverseParsesBack(t, schema, value) {
  t.deepEqual(S$RescriptSchema.parseOrThrow(S$RescriptSchema.reverseConvertOrThrow(value, schema), schema), value, undefined);
}

var assertEqualSchemas = unsafeAssertEqualSchemas;

export {
  unsafeGetVariantPayload ,
  Test ,
  raiseTestException ,
  error ,
  assertThrowsTestException ,
  assertRaised ,
  assertRaisedAsync ,
  getCompiledCodeString ,
  cleanUpSchema ,
  unsafeAssertEqualSchemas ,
  assertCompiledCode ,
  assertCompiledCodeIsNoop ,
  assertEqualSchemas ,
  assertReverseParsesBack ,
}
/* S-RescriptSchema Not a pure module */
