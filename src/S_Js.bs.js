// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var S = require("./S.bs.js");
var Js_exn = require("rescript/lib/js/js_exn.js");
var Caml_js_exceptions = require("rescript/lib/js/caml_js_exceptions.js");

var structOperations = {};

function parse(data) {
  var struct = this;
  try {
    return S.parseOrRaiseWith(data, struct);
  }
  catch (raw_error){
    var error = Caml_js_exceptions.internalToOCamlException(raw_error);
    if (error.RE_EXN_ID === S.Raised) {
      return Js_exn.raiseError(S.$$Error.toString(error._1));
    }
    throw error;
  }
}

function parseAsync(data) {
  var struct = this;
  return S.parseAsyncWith(data, struct).then(function (result) {
              if (result.TAG === /* Ok */0) {
                return result._0;
              } else {
                return Js_exn.raiseError(S.$$Error.toString(result._0));
              }
            });
}

function serialize(value) {
  var struct = this;
  try {
    return S.serializeOrRaiseWith(value, struct);
  }
  catch (raw_error){
    var error = Caml_js_exceptions.internalToOCamlException(raw_error);
    if (error.RE_EXN_ID === S.Raised) {
      return Js_exn.raiseError(S.$$Error.toString(error._1));
    }
    throw error;
  }
}

function transform(parser, serializer) {
  var struct = this;
  var struct$1 = S.transform(struct, parser, serializer, undefined);
  return Object.assign(struct$1, structOperations);
}

function refine(parser, serializer) {
  var struct = this;
  var struct$1 = S.refine(struct, parser, serializer, undefined);
  return Object.assign(struct$1, structOperations);
}

function asyncRefine(parser) {
  var struct = this;
  var struct$1 = S.asyncRefine(struct, parser, undefined);
  return Object.assign(struct$1, structOperations);
}

function string(param) {
  var struct = S.string(undefined);
  return Object.assign(struct, structOperations);
}

function $$boolean(param) {
  var struct = S.bool(undefined);
  return Object.assign(struct, structOperations);
}

function integer(param) {
  var struct = S.$$int(undefined);
  return Object.assign(struct, structOperations);
}

function number(param) {
  var struct = S.$$float(undefined);
  return Object.assign(struct, structOperations);
}

function never(param) {
  var struct = S.never(undefined);
  return Object.assign(struct, structOperations);
}

function unknown(param) {
  var struct = S.unknown(undefined);
  return Object.assign(struct, structOperations);
}

function optional(struct) {
  var struct$1 = S.option(struct);
  return Object.assign(struct$1, structOperations);
}

function nullable(struct) {
  var struct$1 = S.$$null(struct);
  return Object.assign(struct$1, structOperations);
}

function object(definer) {
  var struct = S.object(function (o) {
        var definition = {};
        var fieldNames = Object.keys(definer);
        for(var idx = 0 ,idx_finish = fieldNames.length; idx < idx_finish; ++idx){
          var fieldName = fieldNames[idx];
          var struct = definer[fieldName];
          definition[fieldName] = S.field(o, fieldName, struct);
        }
        return definition;
      });
  return Object.assign(struct, structOperations);
}

Object.assign(structOperations, {
      parse: parse,
      parseAsync: parseAsync,
      serialize: serialize,
      transform: transform,
      refine: refine,
      asyncRefine: asyncRefine,
      optional: (function (param) {
          return optional(this);
        }),
      nullable: (function (param) {
          return nullable(this);
        })
    });

exports.string = string;
exports.$$boolean = $$boolean;
exports.integer = integer;
exports.number = number;
exports.never = never;
exports.unknown = unknown;
exports.optional = optional;
exports.nullable = nullable;
exports.object = object;
/*  Not a pure module */
