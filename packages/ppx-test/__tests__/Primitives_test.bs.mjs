// Generated by ReScript, PLEASE EDIT WITH CARE

import Ava from "ava";
import * as TestUtils from "./TestUtils.bs.mjs";
import * as S$RescriptStruct from "rescript-struct/src/S.bs.mjs";

Ava("String struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.string, S$RescriptStruct.string, undefined, undefined);
      }));

Ava("Int struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.$$int, S$RescriptStruct.$$int, undefined, undefined);
      }));

Ava("Float struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.$$float, S$RescriptStruct.$$float, undefined, undefined);
      }));

Ava("Bool struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.bool, S$RescriptStruct.bool, undefined, undefined);
      }));

Ava("Unit struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.unit, S$RescriptStruct.unit, undefined, undefined);
      }));

Ava("Unknown struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.unknown, S$RescriptStruct.unknown, undefined, undefined);
      }));

Ava("Never struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.never, S$RescriptStruct.never, undefined, undefined);
      }));

var myOptionOfStringStruct = S$RescriptStruct.option(S$RescriptStruct.string);

Ava("Option of string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myOptionOfStringStruct, S$RescriptStruct.option(S$RescriptStruct.string), undefined, undefined);
      }));

var myArrayOfStringStruct = S$RescriptStruct.array(S$RescriptStruct.string);

Ava("Array of string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myArrayOfStringStruct, S$RescriptStruct.array(S$RescriptStruct.string), undefined, undefined);
      }));

var myListOfStringStruct = S$RescriptStruct.list(S$RescriptStruct.string);

Ava("List of string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myListOfStringStruct, S$RescriptStruct.list(S$RescriptStruct.string), undefined, undefined);
      }));

var myDictOfStringStruct = S$RescriptStruct.dict(S$RescriptStruct.string);

Ava("Dict of string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myDictOfStringStruct, S$RescriptStruct.dict(S$RescriptStruct.string), undefined, undefined);
      }));

var myDictOfStringFromCoreStruct = S$RescriptStruct.dict(S$RescriptStruct.string);

Ava("Dict of string struct from Core", (function (t) {
        TestUtils.assertEqualStructs(t, myDictOfStringFromCoreStruct, S$RescriptStruct.dict(S$RescriptStruct.string), undefined, undefined);
      }));

Ava("Json struct", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.json, S$RescriptStruct.json, undefined, undefined);
      }));

Ava("Json struct from Core", (function (t) {
        TestUtils.assertEqualStructs(t, S$RescriptStruct.json, S$RescriptStruct.json, undefined, undefined);
      }));

var myTupleStruct = S$RescriptStruct.Tuple.factory([
      S$RescriptStruct.string,
      S$RescriptStruct.$$int
    ]);

Ava("Tuple struct", (function (t) {
        TestUtils.assertEqualStructs(t, myTupleStruct, S$RescriptStruct.tuple2(S$RescriptStruct.string, S$RescriptStruct.$$int), undefined, undefined);
      }));

var myBigTupleStruct = S$RescriptStruct.Tuple.factory([
      S$RescriptStruct.string,
      S$RescriptStruct.string,
      S$RescriptStruct.string,
      S$RescriptStruct.$$int,
      S$RescriptStruct.$$int,
      S$RescriptStruct.$$int,
      S$RescriptStruct.$$float,
      S$RescriptStruct.$$float,
      S$RescriptStruct.$$float,
      S$RescriptStruct.bool,
      S$RescriptStruct.bool,
      S$RescriptStruct.bool
    ]);

Ava("Big tuple struct", (function (t) {
        TestUtils.assertEqualStructs(t, myBigTupleStruct, S$RescriptStruct.Tuple.factory([
                  S$RescriptStruct.string,
                  S$RescriptStruct.string,
                  S$RescriptStruct.string,
                  S$RescriptStruct.$$int,
                  S$RescriptStruct.$$int,
                  S$RescriptStruct.$$int,
                  S$RescriptStruct.$$float,
                  S$RescriptStruct.$$float,
                  S$RescriptStruct.$$float,
                  S$RescriptStruct.bool,
                  S$RescriptStruct.bool,
                  S$RescriptStruct.bool
                ]), undefined, undefined);
      }));

var myCustomStringStruct = S$RescriptStruct.$$String.email(S$RescriptStruct.string, undefined, undefined);

Ava("Custom string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myCustomStringStruct, S$RescriptStruct.$$String.email(S$RescriptStruct.string, undefined, undefined), undefined, undefined);
      }));

var myCustomLiteralStringStruct = S$RescriptStruct.$$String.email(S$RescriptStruct.literal("123"), undefined, undefined);

Ava("Custom litaral string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myCustomLiteralStringStruct, S$RescriptStruct.$$String.email(S$RescriptStruct.literal("123"), undefined, undefined), undefined, undefined);
      }));

var myCustomOptionalStringStruct = S$RescriptStruct.option(S$RescriptStruct.$$String.email(S$RescriptStruct.string, undefined, undefined));

Ava("Custom optional string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myCustomOptionalStringStruct, S$RescriptStruct.option(S$RescriptStruct.$$String.email(S$RescriptStruct.string, undefined, undefined)), undefined, undefined);
      }));

var myNullOfStringStruct = S$RescriptStruct.$$null(S$RescriptStruct.string);

Ava("Null of string struct", (function (t) {
        TestUtils.assertEqualStructs(t, myNullOfStringStruct, S$RescriptStruct.$$null(S$RescriptStruct.string), undefined, undefined);
      }));

var myStringStruct = S$RescriptStruct.string;

var myIntStruct = S$RescriptStruct.$$int;

var myFloatStruct = S$RescriptStruct.$$float;

var myBoolStruct = S$RescriptStruct.bool;

var myUnitStruct = S$RescriptStruct.unit;

var myUnknownStruct = S$RescriptStruct.unknown;

var myNeverStruct = S$RescriptStruct.never;

var myJsonStruct = S$RescriptStruct.json;

var myJsonFromCoreStruct = S$RescriptStruct.json;

export {
  myStringStruct ,
  myIntStruct ,
  myFloatStruct ,
  myBoolStruct ,
  myUnitStruct ,
  myUnknownStruct ,
  myNeverStruct ,
  myOptionOfStringStruct ,
  myArrayOfStringStruct ,
  myListOfStringStruct ,
  myDictOfStringStruct ,
  myDictOfStringFromCoreStruct ,
  myJsonStruct ,
  myJsonFromCoreStruct ,
  myTupleStruct ,
  myBigTupleStruct ,
  myCustomStringStruct ,
  myCustomLiteralStringStruct ,
  myCustomOptionalStringStruct ,
  myNullOfStringStruct ,
}
/*  Not a pure module */
