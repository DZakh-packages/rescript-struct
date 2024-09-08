open Ava

@dead
type rating =
  | @as("G") GeneralAudiences
  | @as("PG") ParentalGuidanceSuggested
  | @as("PG13") ParentalStronglyCautioned
  | @as("R") Restricted

@dead
type film = {
  id: float,
  title: string,
  tags: array<string>,
  rating: rating,
  deprecatedAgeRestriction: option<int>,
}

let filmSchema = S.object(s => {
  id: s.field("Id", S.float),
  title: s.field("Title", S.string),
  tags: s.fieldOr("Tags", S.array(S.string), []),
  rating: s.field(
    "Rating",
    S.union([
      S.literal(GeneralAudiences),
      S.literal(ParentalGuidanceSuggested),
      S.literal(ParentalStronglyCautioned),
      S.literal(Restricted),
    ]),
  ),
  deprecatedAgeRestriction: s.field("Age", S.option(S.int)->S.deprecate("Use rating instead")),
})

test("Example", t => {
  t->Assert.deepEqual(
    %raw(`{"Id": 1, "Title": "My first film", "Rating": "R", "Age": 17}`)->S.parseWith(filmSchema),
    Ok({
      id: 1.,
      title: "My first film",
      tags: [],
      rating: Restricted,
      deprecatedAgeRestriction: Some(17),
    }),
    (),
  )
  t->Assert.deepEqual(
    {
      id: 2.,
      tags: ["Loved"],
      title: "Sad & sed",
      rating: ParentalStronglyCautioned,
      deprecatedAgeRestriction: None,
    }->S.serializeWith(filmSchema),
    Ok(
      %raw(`{
        "Id": 2,
        "Title": "Sad & sed",
        "Rating": "PG13",
        "Tags": ["Loved"],
        "Age": undefined,
      }`),
    ),
    (),
  )
})

test("Compiled parse code snapshot", t => {
  t->U.assertCompiledCode(
    ~schema=filmSchema,
    ~op=#Parse,
    `i=>{if(!i||i.constructor!==Object){e[7](i)}let v0=i["Id"],v1=i["Title"],v2=i["Tags"],v6=i["Rating"],v7=i["Age"];if(typeof v0!=="number"||Number.isNaN(v0)){e[0](v0)}if(typeof v1!=="string"){e[1](v1)}if(v2!==void 0&&(!Array.isArray(v2))){e[2](v2)}if(v2!==void 0){for(let v3=0;v3<v2.length;++v3){let v5=v2[v3];try{if(typeof v5!=="string"){e[3](v5)}}catch(v4){if(v4&&v4.s===s){v4.path="[\\"Tags\\"]"+\'["\'+v3+\'"]\'+v4.path}throw v4}}}if(v6!=="G"){if(v6!=="PG"){if(v6!=="PG13"){if(v6!=="R"){e[5](v6)}}}}if(v7!==void 0&&(typeof v7!=="number"||v7>2147483647||v7<-2147483648||v7%1!==0)){e[6](v7)}return {"id":v0,"title":v1,"tags":v2===void 0?e[4]:v2,"rating":v6,"deprecatedAgeRestriction":v7,}}`,
  )
})

test("Compiled serialize code snapshot", t => {
  t->U.assertCompiledCode(
    ~schema=filmSchema,
    ~op=#Serialize,
    `i=>{let v0=i["tags"],v4,v5=i["rating"],v6,v7=i["deprecatedAgeRestriction"],v8;if(v0!==void 0){let v1=e[0](v0);v4=v1}try{if(v5!=="G"){e[1](v5)}v6=v5}catch(e0){try{if(v5!=="PG"){e[2](v5)}v6=v5}catch(e1){try{if(v5!=="PG13"){e[3](v5)}v6=v5}catch(e2){try{if(v5!=="R"){e[4](v5)}v6=v5}catch(e3){e[5]([e0,e1,e2,e3,])}}}}if(v7!==void 0){v8=e[6](v7)}return {"Id":i["id"],"Title":i["title"],"Tags":v4,"Rating":v6,"Age":v8,}}`,
  )
})
