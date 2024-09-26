open Ava

module Common = {
  let value = 123
  let any = %raw(`123`)
  let invalidAny = %raw(`123.45`)
  let factory = () => S.int

  test("Successfully parses", t => {
    let schema = factory()

    t->Assert.deepEqual(any->S.parseAnyWith(schema), Ok(value), ())
  })

  test("Fails to parse", t => {
    let schema = factory()

    t->U.assertErrorResult(
      invalidAny->S.parseAnyWith(schema),
      {
        code: InvalidType({expected: schema->S.toUnknown, received: invalidAny}),
        operation: Parse,
        path: S.Path.empty,
      },
    )
  })

  test("Successfully serializes", t => {
    let schema = factory()

    t->Assert.deepEqual(value->S.serializeToUnknownWith(schema), Ok(any), ())
  })

  test("Compiled parse code snapshot", t => {
    let schema = factory()

    t->U.assertCompiledCode(
      ~schema,
      ~op=#Parse,
      `i=>{if(typeof i!=="number"||i>2147483647||i<-2147483648||i%1!==0){e[0](i)}return i}`,
    )
  })

  test("Compiled serialize code snapshot", t => {
    let schema = factory()

    t->U.assertCompiledCodeIsNoop(~schema, ~op=#Serialize)
  })

  test("Reverse schema to self", t => {
    let schema = factory()
    t->Assert.is(schema->S.\"~experimentalReverse", schema->S.toUnknown, ())
  })

  test("Succesfully uses reversed schema for parsing back to initial value", t => {
    let schema = factory()
    t->U.assertReverseParsesBack(schema, 123)
  })
}

test("Fails to parse int when JSON is a number bigger than +2^31", t => {
  let schema = S.int

  t->U.assertErrorResult(
    %raw(`2147483648`)->S.parseAnyWith(schema),
    {
      code: InvalidType({expected: schema->S.toUnknown, received: %raw(`2147483648`)}),
      operation: Parse,
      path: S.Path.empty,
    },
  )
  t->Assert.deepEqual(%raw(`2147483647`)->S.parseAnyWith(schema), Ok(2147483647), ())
})

test("Fails to parse int when JSON is a number lower than -2^31", t => {
  let schema = S.int

  t->U.assertErrorResult(
    %raw(`-2147483649`)->S.parseAnyWith(schema),
    {
      code: InvalidType({expected: schema->S.toUnknown, received: %raw(`-2147483649`)}),
      operation: Parse,
      path: S.Path.empty,
    },
  )
  t->Assert.deepEqual(%raw(`-2147483648`)->S.parseAnyWith(schema), Ok(-2147483648), ())
})

test("Fails to parse NaN", t => {
  let schema = S.int

  t->U.assertErrorResult(
    %raw(`NaN`)->S.parseAnyWith(schema),
    {
      code: InvalidType({expected: schema->S.toUnknown, received: %raw(`NaN`)}),
      operation: Parse,
      path: S.Path.empty,
    },
  )
})
