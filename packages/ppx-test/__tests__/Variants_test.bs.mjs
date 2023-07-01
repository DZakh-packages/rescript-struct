// Generated by ReScript, PLEASE EDIT WITH CARE

import Ava from "ava";
import * as TestUtils from "./TestUtils.bs.mjs";
import * as S$RescriptStruct from "rescript-struct/src/S.bs.mjs";

var variantStruct = S$RescriptStruct.union([
      S$RescriptStruct.literal("One"),
      S$RescriptStruct.literal("Two")
    ]);

Ava("Variant", (function (t) {
        TestUtils.assertEqualStructs(t, variantStruct, S$RescriptStruct.union([
                  S$RescriptStruct.literal("One"),
                  S$RescriptStruct.literal("Two")
                ]), undefined, undefined);
      }));

var variantWithSingleItemStruct = S$RescriptStruct.literal("Single");

Ava("Variant with single item becomes a literal struct of the item", (function (t) {
        TestUtils.assertEqualStructs(t, variantWithSingleItemStruct, S$RescriptStruct.literal("Single"), undefined, undefined);
      }));

var variantWithAliasStruct = S$RescriptStruct.union([
      S$RescriptStruct.literal("하나"),
      S$RescriptStruct.literal("Two")
    ]);

Ava("Variant with partial @as usage", (function (t) {
        TestUtils.assertEqualStructs(t, variantWithAliasStruct, S$RescriptStruct.union([
                  S$RescriptStruct.literal("하나"),
                  S$RescriptStruct.literal("Two")
                ]), undefined, undefined);
      }));

export {
  variantStruct ,
  variantWithSingleItemStruct ,
  variantWithAliasStruct ,
}
/* variantStruct Not a pure module */
