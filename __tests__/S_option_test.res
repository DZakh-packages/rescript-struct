open Ava

module Common = {
  let value = None
  let any = %raw(`undefined`)
  let wrongAny = %raw(`123.45`)
  let jsonString = `undefined`
  let wrongJsonString = `123.45`
  let factory = () => S.option(S.string())

  test("Successfully constructs", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.constructWith(struct), Ok(value), ())
  })

  test("Successfully constructs without validation. Note: Use S.parseWith instead", t => {
    let struct = factory()

    t->Assert.deepEqual(wrongAny->S.constructWith(struct), Ok(wrongAny), ())
  })

  test("Successfully destructs", t => {
    let struct = factory()

    t->Assert.deepEqual(value->S.destructWith(struct), Ok(any), ())
  })

  test("Successfully parses", t => {
    let struct = factory()

    t->Assert.deepEqual(any->S.parseWith(struct), Ok(value), ())
  })

  test("Fails to parse", t => {
    let struct = factory()

    t->Assert.deepEqual(
      wrongAny->S.parseWith(struct),
      Error("[ReScript Struct] Failed parsing at root. Reason: Expected String, got Float"),
      (),
    )
  })

  failing("Successfully parses from JSON string", t => {
    let struct = factory()

    t->Assert.deepEqual(jsonString->S.parseJsonWith(struct), Ok(value), ())
  })

  test("Fails to parse from JSON string", t => {
    let struct = factory()

    t->Assert.deepEqual(
      wrongJsonString->S.parseJsonWith(struct),
      Error(`[ReScript Struct] Failed parsing at root. Reason: Expected String, got Float`),
      (),
    )
  })

  // FIXME: It should fail with serializing error
  failing("Successfully serializes to JSON string", t => {
    let struct = factory()

    t->Assert.deepEqual(value->S.serializeJsonWith(struct), Ok(jsonString), ())
  })
}

test("Successfully parses primitive", t => {
  let struct = S.option(S.bool())

  t->Assert.deepEqual(Js.Json.boolean(true)->S.parseWith(struct), Ok(Some(true)), ())
})

test("Fails to parse JS null", t => {
  let struct = S.option(S.bool())

  t->Assert.deepEqual(
    %raw(`null`)->S.parseWith(struct),
    Error("[ReScript Struct] Failed parsing at root. Reason: Expected Bool, got Null"),
    (),
  )
})

test("Fails to parse JS undefined when struct doesn't allow optional data", t => {
  let struct = S.bool()

  t->Assert.deepEqual(
    %raw(`undefined`)->S.parseWith(struct),
    Error("[ReScript Struct] Failed parsing at root. Reason: Expected Bool, got Option"),
    (),
  )
})

todo("Fails to serialize undefined to JSON string")
