// Generated by ReScript, PLEASE EDIT WITH CARE

import * as U from "../utils/U.res.mjs";
import Ava from "ava";
import * as S$RescriptSchema from "rescript-schema/src/S.res.mjs";

let simpleObjectSchema = S$RescriptSchema.schema(s => ({
  label: s.m(S$RescriptSchema.string),
  value: s.m(S$RescriptSchema.int)
}));

Ava("Simple object schema", t => {
  U.assertEqualSchemas(t, simpleObjectSchema, S$RescriptSchema.object(s => ({
    label: s.f("label", S$RescriptSchema.string),
    value: s.f("value", S$RescriptSchema.int)
  })), undefined);
  t.deepEqual(S$RescriptSchema.parseOrThrow({label:"foo",value:1}, simpleObjectSchema), {
    label: "foo",
    value: 1
  }, undefined);
});

export {
  simpleObjectSchema,
}
/* simpleObjectSchema Not a pure module */
