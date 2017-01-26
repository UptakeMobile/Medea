# Medea

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A bag of functions (living in `JSONHelper`) for converting to and from JSON representations. It's a *very* thin wrapper around `JSONSerialization` that also:
 
 * Is *explicit* about whether JSON is expected to be an object or an array, throwing an error if an unexpected type is encountered.

 * Handles all the conversions between `Data` and `String`, eliminating a lot of `Optional`s and `guards` in the process.

 * Converts some common `JSONSerialization` errors out of the `NSCocoaErrorDomain` and into the easier-to-catch `JSONError` enum.

 * Provides convenience types for `JSONObject` and `JSONArray` to save you from having to type `AnyHashable` or make sense of the oblique `[Any]`.

 * Provides easy validation functions for verifying `Data`s, `String`s, `JSONObject`s or `JSONArray`s represent well-formed JSON — without having to chain a bunch of conversions and `try`.

## Usage

### From JSON:

```swift
let object  = try JSONHelper.jsonObject(from: "{\"foo\": 42}")
let array   = try JSONHelper.jsonArray(from: "[42, 64, 10175]")
let isValid = JSONHelper.isValid("{\"numbers\": [1,2,3]}")
try JSONHelper.validate("[1,true,null]")
```

### To JSON:

```swift
let jsonString = try JSONHelper.string(from: ["foo": 42])
let jsonData   = try JSONHelper.data(from: [42, 64, 10175])
let isValid    = JSONHelper.isValid(["invalid": Date()])
try JSONHelper.validate([1, true, NSNull()])
```

## API
Full API documentation [can be found here](https://jemmons.github.io/Medea/Enums/JSONHelper.html).