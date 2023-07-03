open Ava

test("Throws for a Union struct factory without structs", t => {
  t->Assert.throws(
    () => {
      S.union([])
    },
    ~expectations={
      message: "[rescript-struct] A Union struct factory require at least two structs.",
    },
    (),
  )
})

test("Throws for a Union struct factory with single struct", t => {
  t->Assert.throws(
    () => {
      S.union([S.string])
    },
    ~expectations={
      message: "[rescript-struct] A Union struct factory require at least two structs.",
    },
    (),
  )
})

test("Successfully creates a Union struct factory with two structs", t => {
  t->Assert.notThrows(() => {
    S.union([S.string, S.string])->ignore
  }, ())
})

test("Successfully parses polymorphic variants", t => {
  let struct = S.union([S.literal(#apple), S.literal(#orange)])

  t->Assert.deepEqual(%raw(`"apple"`)->S.parseAnyWith(struct), Ok(#apple), ())
})

module Advanced = {
  // TypeScript type for reference (https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html#discriminated-unions)
  // type Shape =
  // | { kind: "circle"; radius: number }
  // | { kind: "square"; x: number }
  // | { kind: "triangle"; x: number; y: number };

  type shape = Circle({radius: float}) | Square({x: float}) | Triangle({x: float, y: float})

  let shapeStruct = S.union([
    S.object(o => {
      o.tag("kind", "circle")
      Circle({
        radius: o.field("radius", S.float),
      })
    }),
    S.object(o => {
      o.tag("kind", "square")
      Square({
        x: o.field("x", S.float),
      })
    }),
    S.object(o => {
      o.tag("kind", "triangle")
      Triangle({
        x: o.field("x", S.float),
        y: o.field("y", S.float),
      })
    }),
  ])

  test("Successfully parses Circle shape", t => {
    t->Assert.deepEqual(
      %raw(`{
      "kind": "circle",
      "radius": 1,
    }`)->S.parseAnyWith(shapeStruct),
      Ok(Circle({radius: 1.})),
      (),
    )
  })

  test("Successfully parses Square shape", t => {
    t->Assert.deepEqual(
      %raw(`{
      "kind": "square",
      "x": 2,
    }`)->S.parseAnyWith(shapeStruct),
      Ok(Square({x: 2.})),
      (),
    )
  })

  test("Successfully parses Triangle shape", t => {
    t->Assert.deepEqual(
      %raw(`{
      "kind": "triangle",
      "x": 2,
      "y": 3,
    }`)->S.parseAnyWith(shapeStruct),
      Ok(Triangle({x: 2., y: 3.})),
      (),
    )
  })

  test("Fails to parse with unknown kind", t => {
    t->Assert.deepEqual(
      %raw(`{
        "kind": "oval",
        "x": 2,
        "y": 3,
      }`)->S.parseAnyWith(shapeStruct),
      Error({
        code: InvalidUnion([
          {
            code: InvalidLiteral({expected: String("circle"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
          {
            code: InvalidLiteral({expected: String("square"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
          {
            code: InvalidLiteral({expected: String("triangle"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
        ]),
        operation: Parsing,
        path: S.Path.empty,
      }),
      (),
    )
  })

  test("Fails to parse with unknown kind when the union is an object field", t => {
    t->Assert.deepEqual(
      %raw(`{
        "field": {
          "kind": "oval",
          "x": 2,
          "y": 3,
        }
      }`)->S.parseAnyWith(S.object(o => o.field("field", shapeStruct))),
      Error({
        code: InvalidUnion([
          {
            code: InvalidLiteral({expected: String("circle"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
          {
            code: InvalidLiteral({expected: String("square"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
          {
            code: InvalidLiteral({expected: String("triangle"), received: "oval"->Obj.magic}),
            operation: Parsing,
            path: S.Path.fromArray(["kind"]),
          },
        ]),
        operation: Parsing,
        path: S.Path.fromArray(["field"]),
      }),
      (),
    )
  })

  test("Fails to parse with wrong data type", t => {
    t->Assert.deepEqual(
      %raw(`"Hello world!"`)->S.parseAnyWith(shapeStruct),
      Error({
        code: InvalidUnion([
          {
            code: InvalidType({expected: "Object", received: "String"}),
            operation: Parsing,
            path: S.Path.empty,
          },
          {
            code: InvalidType({expected: "Object", received: "String"}),
            operation: Parsing,
            path: S.Path.empty,
          },
          {
            code: InvalidType({expected: "Object", received: "String"}),
            operation: Parsing,
            path: S.Path.empty,
          },
        ]),
        operation: Parsing,
        path: S.Path.empty,
      }),
      (),
    )
  })

  test("Fails to serialize incomplete struct", t => {
    let incompleteStruct = S.union([
      S.object(o => {
        o.tag("kind", "circle")
        Circle({
          radius: o.field("radius", S.float),
        })
      }),
      S.object(o => {
        o.tag("kind", "square")
        Square({
          x: o.field("x", S.float),
        })
      }),
    ])

    t->Assert.deepEqual(
      Triangle({x: 2., y: 3.})->S.serializeToUnknownWith(incompleteStruct),
      Error({
        code: InvalidUnion([
          {
            code: InvalidLiteral({expected: String("Circle"), received: "Triangle"->Obj.magic}),
            operation: Serializing,
            path: S.Path.fromArray(["TAG"]),
          },
          {
            code: InvalidLiteral({expected: String("Square"), received: "Triangle"->Obj.magic}),
            operation: Serializing,
            path: S.Path.fromArray(["TAG"]),
          },
        ]),
        operation: Serializing,
        path: S.Path.empty,
      }),
      (),
    )
  })

  test("Successfully serializes Circle shape", t => {
    t->Assert.deepEqual(
      Circle({radius: 1.})->S.serializeToUnknownWith(shapeStruct),
      Ok(
        %raw(`{
          "kind": "circle",
          "radius": 1,
        }`),
      ),
      (),
    )
  })

  test("Successfully serializes Square shape", t => {
    t->Assert.deepEqual(
      Square({x: 2.})->S.serializeToUnknownWith(shapeStruct),
      Ok(
        %raw(`{
        "kind": "square",
        "x": 2,
      }`),
      ),
      (),
    )
  })

  test("Successfully serializes Triangle shape", t => {
    t->Assert.deepEqual(
      Triangle({x: 2., y: 3.})->S.serializeToUnknownWith(shapeStruct),
      Ok(
        %raw(`{
        "kind": "triangle",
        "x": 2,
        "y": 3,
      }`),
      ),
      (),
    )
  })
}
