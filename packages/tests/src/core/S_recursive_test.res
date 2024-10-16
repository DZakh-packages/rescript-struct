open Ava
open RescriptCore

type rec node = {
  id: string,
  children: array<node>,
}

test("Successfully parses recursive object", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->Assert.deepEqual(
    {
      "Id": "1",
      "Children": [
        {"Id": "2", "Children": []},
        {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
      ],
    }->S.parseAnyWith(nodeSchema),
    Ok({
      id: "1",
      children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
    }),
    (),
  )
})

test("Fails to parses recursive object when provided invalid type", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->Assert.deepEqual(
    switch {
      "Id": "1",
      "Children": ["invalid"],
    }->S.parseAnyWith(nodeSchema) {
    | Ok(_) => "Shouldn't pass"
    | Error(e) => e->S.Error.message
    },
    `Failed parsing at ["Children"]["0"]. Reason: Expected <recursive>, received "invalid"`,
    (),
  )
})

asyncTest("Successfully parses recursive object using S.parseAsyncWith", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  %raw(`{
    "Id": "1",
    "Children": [
      {"Id": "2", "Children": []},
      {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
    ],
  }`)
  ->S.parseAsyncWith(nodeSchema)
  ->Promise.thenResolve(result => {
    t->Assert.deepEqual(
      result,
      Ok({
        id: "1",
        children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
      }),
      (),
    )
  })
})

test("Successfully serializes recursive object", t => {
  S.setGlobalConfig({})

  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->U.assertCompiledCode(
    ~schema=nodeSchema,
    ~op=#Serialize,
    `i=>{let r0=i=>{let v0=i["children"],v4=[];for(let v1=0;v1<v0.length;++v1){let v3;try{v3=r0(v0[v1])}catch(v2){if(v2&&v2.s===s){v2.path="[\\"children\\"]"+\'["\'+v1+\'"]\'+v2.path}throw v2}v4.push(v3)}return {"Id":i["id"],"Children":v4}};return r0(i)}`,
  )

  t->Assert.deepEqual(
    {
      id: "1",
      children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
    }->S.reverseConvertWith(nodeSchema),
    %raw(`{
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      }`),
    (),
  )
})

test("Fails to parse nested recursive object", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field(
          "Id",
          S.string->S.refine(
            s => id => {
              if id === "4" {
                s.fail("Invalid id")
              }
            },
          ),
        ),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->U.assertErrorResult(
    () =>
      {
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      }->S.parseAnyWith(nodeSchema),
    {
      code: OperationFailed("Invalid id"),
      operation: Parse,
      path: S.Path.fromArray(["Children", "1", "Children", "0", "Id"]),
    },
  )
})

test("Fails to parse nested recursive object inside of another object", t => {
  let schema = S.object(s =>
    s.field(
      "recursive",
      S.recursive(
        nodeSchema => {
          S.object(
            s => {
              id: s.field(
                "Id",
                S.string->S.refine(
                  s => id => {
                    if id === "4" {
                      s.fail("Invalid id")
                    }
                  },
                ),
              ),
              children: s.field("Children", S.array(nodeSchema)),
            },
          )
        },
      ),
    )
  )

  t->U.assertErrorResult(
    () =>
      {
        "recursive": {
          "Id": "1",
          "Children": [
            {"Id": "2", "Children": []},
            {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
          ],
        },
      }->S.parseAnyWith(schema),
    {
      code: OperationFailed("Invalid id"),
      operation: Parse,
      path: S.Path.fromArray(["recursive", "Children", "1", "Children", "0", "Id"]),
    },
  )
})

test("Parses multiple nested recursive object inside of another object", t => {
  S.setGlobalConfig({})

  let schema = S.object(s =>
    {
      "recursive1": s.field(
        "recursive1",
        S.recursive(
          nodeSchema => {
            S.object(
              s => {
                id: s.field("Id", S.string),
                children: s.field("Children", S.array(nodeSchema)),
              },
            )
          },
        ),
      ),
      "recursive2": s.field(
        "recursive2",
        S.recursive(
          nodeSchema => {
            S.object(
              s => {
                id: s.field("Id", S.string),
                children: s.field("Children", S.array(nodeSchema)),
              },
            )
          },
        ),
      ),
    }
  )

  t->U.assertCompiledCode(
    ~schema,
    ~op=#Parse,
    `i=>{if(!i||i.constructor!==Object){e[8](i)}let v0=i["recursive1"],v10=i["recursive2"];if(!v0||v0.constructor!==Object){e[0](v0)}let v9;let r0=v0=>{let v1=v0["Id"],v2=v0["Children"];if(typeof v1!=="string"){e[1](v1)}if(!Array.isArray(v2)){e[2](v2)}let v7=[];for(let v3=0;v3<v2.length;++v3){let v5=v2[v3],v6;try{if(!v5||v5.constructor!==Object){e[3](v5)}v6=r0(v5)}catch(v4){if(v4&&v4.s===s){v4.path="[\\"Children\\"]"+\'["\'+v3+\'"]\'+v4.path}throw v4}v7.push(v6)}return {"id":v1,"children":v7}};try{v9=r0(v0)}catch(v8){if(v8&&v8.s===s){v8.path="[\\"recursive1\\"]"+v8.path}throw v8}if(!v10||v10.constructor!==Object){e[4](v10)}let v19;let r1=v10=>{let v11=v10["Id"],v12=v10["Children"];if(typeof v11!=="string"){e[5](v11)}if(!Array.isArray(v12)){e[6](v12)}let v17=[];for(let v13=0;v13<v12.length;++v13){let v15=v12[v13],v16;try{if(!v15||v15.constructor!==Object){e[7](v15)}v16=r1(v15)}catch(v14){if(v14&&v14.s===s){v14.path="[\\"Children\\"]"+\'["\'+v13+\'"]\'+v14.path}throw v14}v17.push(v16)}return {"id":v11,"children":v17}};try{v19=r1(v10)}catch(v18){if(v18&&v18.s===s){v18.path="[\\"recursive2\\"]"+v18.path}throw v18}return {"recursive1":v9,"recursive2":v19}}`,
  )

  t->Assert.deepEqual(
    {
      "recursive1": {
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      },
      "recursive2": {
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      },
    }->S.parseAnyWith(schema),
    Ok({
      "recursive1": {
        id: "1",
        children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
      },
      "recursive2": {
        id: "1",
        children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
      },
    }),
    (),
  )
})

test("Fails to serialise nested recursive object", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field(
          "Id",
          S.string->S.refine(
            s => id => {
              if id === "4" {
                s.fail("Invalid id")
              }
            },
          ),
        ),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->U.assertRaised(
    () =>
      {
        id: "1",
        children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
      }->S.reverseConvertWith(nodeSchema),
    {
      code: OperationFailed("Invalid id"),
      operation: ReverseConvert,
      path: S.Path.fromArray(["children", "1", "children", "0", "id"]),
    },
  )
})

test(
  "Recursively transforms all objects when added transform to the recursive's function returned schema",
  t => {
    let nodeSchema = S.recursive(nodeSchema => {
      S.object(
        s => {
          id: s.field("Id", S.string),
          children: s.field("Children", S.array(nodeSchema)),
        },
      )->S.transform(
        _ => {
          parser: node => {...node, id: `node_${node.id}`},
          serializer: node => {...node, id: node.id->String.sliceToEnd(~start=5)},
        },
      )
    })

    t->Assert.deepEqual(
      {
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      }->S.parseAnyWith(nodeSchema),
      Ok({
        id: "node_1",
        children: [
          {id: "node_2", children: []},
          {id: "node_3", children: [{id: "node_4", children: []}]},
        ],
      }),
      (),
    )
    t->Assert.deepEqual(
      {
        id: "node_1",
        children: [
          {id: "node_2", children: []},
          {id: "node_3", children: [{id: "node_4", children: []}]},
        ],
      }->S.reverseConvertWith(nodeSchema),
      {
        "Id": "1",
        "Children": [
          {"Id": "2", "Children": []},
          {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
        ],
      }->Obj.magic,
      (),
    )
  },
)

test("Recursively transforms nested objects when added transform to the placeholder schema", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field(
          "Children",
          S.array(
            nodeSchema->S.transform(
              _ => {
                parser: node => {...node, id: `child_${node.id}`},
                serializer: node => {...node, id: node.id->String.sliceToEnd(~start=6)},
              },
            ),
          ),
        ),
      },
    )
  })

  t->Assert.deepEqual(
    {
      "Id": "1",
      "Children": [
        {"Id": "2", "Children": []},
        {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
      ],
    }->S.parseAnyWith(nodeSchema),
    Ok({
      id: "1",
      children: [
        {id: "child_2", children: []},
        {id: "child_3", children: [{id: "child_4", children: []}]},
      ],
    }),
    (),
  )
  t->Assert.deepEqual(
    {
      id: "1",
      children: [
        {id: "child_2", children: []},
        {id: "child_3", children: [{id: "child_4", children: []}]},
      ],
    }->S.reverseConvertWith(nodeSchema),
    {
      "Id": "1",
      "Children": [
        {"Id": "2", "Children": []},
        {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
      ],
    }->Obj.magic,
    (),
  )
})

test("Shallowly transforms object when added transform to the S.recursive result", t => {
  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })->S.transform(_ => {
    parser: node => {...node, id: `parent_${node.id}`},
    serializer: node => {...node, id: node.id->String.sliceToEnd(~start=7)},
  })

  t->Assert.deepEqual(
    {
      "Id": "1",
      "Children": [
        {"Id": "2", "Children": []},
        {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
      ],
    }->S.parseAnyWith(nodeSchema),
    Ok({
      id: "parent_1",
      children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
    }),
    (),
  )
  t->Assert.deepEqual(
    {
      id: "parent_1",
      children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
    }->S.reverseConvertWith(nodeSchema),
    {
      "Id": "1",
      "Children": [
        {"Id": "2", "Children": []},
        {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
      ],
    }->Obj.magic,
    (),
  )
})

test("Creates schema without async parse function using S.recursive", t => {
  t->Assert.notThrows(() => {
    S.recursive(
      nodeSchema => {
        S.object(
          s => {
            id: s.field("Id", S.string),
            children: s.field("Children", S.array(nodeSchema)),
          },
        )
      },
    )->ignore
  }, ())
})

test("Creates schema with async parse function using S.recursive", t => {
  t->Assert.notThrows(() => {
    S.recursive(
      nodeSchema => {
        S.object(
          s => {
            id: s.field(
              "Id",
              S.string->S.transform(_ => {asyncParser: i => () => Promise.resolve(i)}),
            ),
            children: s.field("Children", S.array(nodeSchema)),
          },
        )
      },
    )->ignore
  }, ())
})

asyncTest("Successfully parses recursive object with async parse function", t => {
  S.setGlobalConfig({})

  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field("Id", S.string->S.transform(_ => {asyncParser: i => () => Promise.resolve(i)})),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  t->U.assertCompiledCode(
    ~schema=nodeSchema,
    ~op=#Parse,
    `i=>{if(!i||i.constructor!==Object){e[4](i)}let r0=i=>{let v0=i["Id"],v1=i["Children"];if(typeof v0!=="string"){e[0](v0)}if(!Array.isArray(v1)){e[2](v1)}let v6=[];for(let v2=0;v2<v1.length;++v2){let v4=v1[v2],v5;try{if(!v4||v4.constructor!==Object){e[3](v4)}v5=r0(v4).catch(v3=>{if(v3&&v3.s===s){v3.path="[\\"Children\\"]"+\'["\'+v2+\'"]\'+v3.path}throw v3})}catch(v3){if(v3&&v3.s===s){v3.path="[\\"Children\\"]"+\'["\'+v2+\'"]\'+v3.path}throw v3}v6.push(v5)}return Promise.all([e[1](v0),Promise.all(v6)]).then(a=>({"id":a[0],"children":a[1]}))};return r0(i)}`,
  )

  %raw(`{
    "Id":"1",
    "Children": [
      {"Id": "2", "Children": []},
      {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
    ],
  }`)
  ->S.parseAsyncWith(nodeSchema)
  ->Promise.thenResolve(result => {
    t->Assert.deepEqual(
      result,
      Ok({
        id: "1",
        children: [{id: "2", children: []}, {id: "3", children: [{id: "4", children: []}]}],
      }),
      (),
    )
  })
})

test("Parses recursive object with async fields in parallel", t => {
  let unresolvedPromise = Promise.make((_, _) => ())
  let actionCounter = ref(0)

  let nodeSchema = S.recursive(nodeSchema => {
    S.object(
      s => {
        id: s.field(
          "Id",
          S.string->S.transform(
            _ => {
              asyncParser: _ => {
                actionCounter.contents = actionCounter.contents + 1
                () => {
                  unresolvedPromise
                }
              },
            },
          ),
        ),
        children: s.field("Children", S.array(nodeSchema)),
      },
    )
  })

  %raw(`{
    "Id": "1",
    "Children": [
      {"Id": "2", "Children": []},
      {"Id": "3", "Children": [{"Id": "4", "Children": []}]},
    ],
  }`)
  ->S.parseAsyncWith(nodeSchema)
  ->ignore

  t->Assert.deepEqual(actionCounter.contents, 4, ())
})

test("Compiled parse code snapshot", t => {
  S.setGlobalConfig({})

  let schema = S.recursive(schema => {
    S.object(
      s => {
        id: s.field("Id", S.string),
        children: s.field("Children", S.array(schema)),
      },
    )
  })

  t->U.assertCompiledCode(
    ~schema,
    ~op=#Parse,
    `i=>{if(!i||i.constructor!==Object){e[3](i)}let r0=i=>{let v0=i["Id"],v1=i["Children"];if(typeof v0!=="string"){e[0](v0)}if(!Array.isArray(v1)){e[1](v1)}let v6=[];for(let v2=0;v2<v1.length;++v2){let v4=v1[v2],v5;try{if(!v4||v4.constructor!==Object){e[2](v4)}v5=r0(v4)}catch(v3){if(v3&&v3.s===s){v3.path="[\\"Children\\"]"+\'["\'+v2+\'"]\'+v3.path}throw v3}v6.push(v5)}return {"id":v0,"children":v6}};return r0(i)}`,
  )
})
