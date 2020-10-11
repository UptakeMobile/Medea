# Medea

[![Swift Package](https://img.shields.io/static/v1?label=Swift&message=Package&logo=Swift&color=fa7343&style=flat)](https://github.com/Apple/swift-package-manager)
[![Documentation](https://jemmons.github.io/Medea/badge.svg)](https://jemmons.github.io/Medea/Enums/JSONHelper.html)
[![Tests](https://github.com/jemmons/Medea/workflows/master/badge.svg)](https://github.com/jemmons/Medea/actions?query=workflow%3A%22master%22)
[![Maintainability](https://api.codeclimate.com/v1/badges/ebe6d495ac3e3c1666a4/maintainability)](https://codeclimate.com/github/jemmons/Medea/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ebe6d495ac3e3c1666a4/test_coverage)](https://codeclimate.com/github/jemmons/Medea/test_coverage)

A bag of functions (living in `JSONHelper`) for converting to and from JSON representations. It's a *very* thin wrapper around `JSONSerialization` that also:
 
 * Is *explicit* about whether JSON is expected to be an object or an array, throwing an error if an unexpected type is encountered.

 * Handles all the conversions between `Data` and `String`, eliminating a lot of `Optional`s and `guards` in the process.

 * Converts some common `JSONSerialization` errors out of the `NSCocoaErrorDomain` and into the easier-to-catch `JSONError` enum.

 * Provides convenience types for `JSONObject` and `JSONArray` to save you from having to make sense of oblique `Any`s.

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
