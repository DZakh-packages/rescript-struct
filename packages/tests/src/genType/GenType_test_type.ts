import { expectType, TypeEqual } from "ts-expect";

import * as S from "../../../../src/S.js";
import * as GenType from "./GenType.gen";

expectType<TypeEqual<typeof GenType.stringStruct, S.Struct<string, unknown>>>(
  true
);
