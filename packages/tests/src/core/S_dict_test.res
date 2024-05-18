open Ava
open RescriptCore

module CommonWithNested = {
  let value = Dict.fromArray([("key1", "value1"), ("key2", "value2")])
  let any = %raw(`{"key1":"value1","key2":"value2"}`)
  let invalidAny = %raw(`true`)
  let nestedInvalidAny = %raw(`{"key1":"value1","key2":true}`)
  let factory = () => S.dict(S.string)

  test("Successfully parses", t => {
    let schema = factory()

    t->Assert.deepEqual(any->S.parseAnyWith(schema), Ok(value), ())
  })

  test("Successfully serializes", t => {
    let schema = factory()

    t->Assert.deepEqual(value->S.serializeToUnknownWith(schema), Ok(any), ())
  })

  test("Fails to parse", t => {
    let schema = factory()

    t->U.assertErrorResult(
      invalidAny->S.parseAnyWith(schema),
      {
        code: InvalidType({expected: schema->S.toUnknown, received: invalidAny}),
        operation: Parsing,
        path: S.Path.empty,
      },
    )
  })

  test("Fails to parse nested", t => {
    let schema = factory()

    t->U.assertErrorResult(
      nestedInvalidAny->S.parseAnyWith(schema),
      {
        code: InvalidType({expected: S.string->S.toUnknown, received: %raw(`true`)}),
        operation: Parsing,
        path: S.Path.fromArray(["key2"]),
      },
    )
  })

  test("Compiled parse code snapshot", t => {
    let schema = factory()

    t->U.assertCompiledCode(
      ~schema,
      ~op=#parse,
      `i=>{if(!i||i.constructor!==Object){e[1](i)}for(let v0 in i){let v2=i[v0];try{if(typeof v2!=="string"){e[0](v2)}}catch(v1){if(v1&&v1.s===s){v1.path=""+\'["\'+v0+\'"]\'+v1.path}throw v1}}return i}`,
    )
  })

  test("Compiled async parse code snapshot", t => {
    let schema = S.dict(S.unknown->S.transform(_ => {asyncParser: i => () => Promise.resolve(i)}))

    t->U.assertCompiledCode(
      ~schema,
      ~op=#parse,
      `i=>{if(!i||i.constructor!==Object){e[1](i)}let v4={};for(let v0 in i){let v2,v3;try{v2=e[0](i[v0]);v3=()=>{try{return v2().catch(v1=>{if(v1&&v1.s===s){v1.path=""+\'["\'+v0+\'"]\'+v1.path}throw v1})}catch(v1){if(v1&&v1.s===s){v1.path=""+\'["\'+v0+\'"]\'+v1.path}throw v1}}}catch(v1){if(v1&&v1.s===s){v1.path=""+\'["\'+v0+\'"]\'+v1.path}throw v1}v4[v0]=v3}return ()=>new Promise((v5,v6)=>{let v8=Object.keys(v4).length;for(let v0 in v4){v4[v0]().then(v7=>{v4[v0]=v7;if(v8--===1){v5(v4)}},v6)}})}`,
    )
  })

  test("Compiled serialize code snapshot", t => {
    let schema = S.dict(S.string)

    t->U.assertCompiledCodeIsNoop(~schema, ~op=#serialize)
  })

  test("Compiled serialize code snapshot with transform", t => {
    let schema = S.dict(S.option(S.string))

    t->U.assertCompiledCode(
      ~schema,
      ~op=#serialize,
      `i=>{let v5={};for(let v0 in i){let v2=i[v0],v4;try{let v3;if(v2!==void 0){v3=e[0](v2)}v4=v3}catch(v1){if(v1&&v1.s===s){v1.path=""+\'["\'+v0+\'"]\'+v1.path}throw v1}v5[v0]=v4}return v5}`,
    )
  })
}

test("Successfully parses dict with int keys", t => {
  let schema = S.dict(S.string)

  t->Assert.deepEqual(
    %raw(`{1:"b",2:"d"}`)->S.parseAnyWith(schema),
    Ok(Dict.fromArray([("1", "b"), ("2", "d")])),
    (),
  )
})

test("Applies operation for each item on serializing", t => {
  let schema = S.dict(S.jsonString(S.int))

  t->Assert.deepEqual(
    Dict.fromArray([("a", 1), ("b", 2)])->S.serializeToUnknownWith(schema),
    Ok(
      %raw(`{
        "a": "1",
        "b": "2",
      }`),
    ),
    (),
  )
})

test("Fails to serialize dict item", t => {
  let schema = S.dict(S.string->S.refine(s => _ => s.fail("User error")))

  t->Assert.deepEqual(
    Dict.fromArray([("a", "aa"), ("b", "bb")])->S.serializeToUnknownWith(schema),
    Error(
      U.error({
        code: OperationFailed("User error"),
        operation: Serializing,
        path: S.Path.fromLocation("a"),
      }),
    ),
    (),
  )
})

test("Successfully parses dict with optional items", t => {
  let schema = S.dict(S.option(S.string))

  t->Assert.deepEqual(
    %raw(`{"key1":"value1","key2":undefined}`)->S.parseAnyWith(schema),
    Ok(Dict.fromArray([("key1", Some("value1")), ("key2", None)])),
    (),
  )
})
