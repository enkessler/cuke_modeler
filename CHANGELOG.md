# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet...

## [3.5.0] - 2020-12-19

### Added
 - Support added for more versions of the `cucumber-gherkin` gem
   - 16.x

## [3.4.0] - 2020-09-02

### Added
 - `Feature#has_background?` and `Rule#has_background?` now both have a more conventional name via the alias `#background?`

## [3.3.0] - 2020-08-15

### Added
 - Support added for more versions of the `cucumber-gherkin` gem
   - 15.x

## [3.2.0] - 2020-07-27

### Added
 - The `Rule` keyword is now a modeled element.

### Deprecated
 - `Feature#test_case_count` will be removed on the next major release. It's a random analysis method in what is 
 otherwise a purely abstraction layer library. The [CQL](https://github.com/enkessler/cql) gem is better suited to such tasks.  

## [3.1.0] - 2020-06-28

### Added
 - Support added for more versions of the `cucumber-gherkin` gem
   - 14.x

### Fixed
  - Text is converted to UTF-8 encoding before being passed to the underlying Gherkin gem. This is due to UTF-8 being 
    the only encoding supported by Gherkin. The `gherkin` gem did the conversion automatically and so this conversion 
    was not necessary previously but the `cucumber-gherkin` gem does not do any automatic conversion.

## [3.0.0] - 2020-06-08

### Changed
 - This gem now wraps the `cucumber-gherkin` gem instead of the `gherkin` gem, now that `cucumber-gherkin` has superseded `gherkin`.
 - Support for versions of Ruby earlier than 2.3 has been dropped due to that being the minimum required version of Ruby required by the `cucumber-gherkin` gem.
 - When using the parsing functionality provided by this gem, the standardized AST returned when parsing Gherkin text is now returned directly as a Hash instead of also being wrapped in an array. The array was an artifact of basing the AST on the earliest versions of `gherkin` that were supported.
 - No longer including every file in the Git repository as part of the gem. Only the files needed for using the gem (and the informative ones like the README) will be packaged into the released gem.

### Added
 - Support added for more versions of the `cucumber-gherkin` gem
   - 13.x
   - 12.x
   - 11.x
   - 10.x
   - 9.x

## [2.1.0] - 2020-05-27

### Added
 - Support added for more versions of the `gherkin` gem
   - 9.x
   - 8.x
   - 7.x

### Fixed
 - Parsing errors are now correctly bubbled up when using Gherkin 6.x

## [2.0.0] - 2020-02-11

### Changed

 - Step models now include doc strings and tables when determining their equality with other steps. Previously, only the base text of the step was included and the doc string/table was explicitly ignored.


## [1.5.1] - 2019-04-14

### Added

 - Add dependency version limits to Ruby which was previously unbound
 - Add dependency version limits to `bundler`, which was previously unbound
 - Added inline documentation to some methods that did not have any

## [1.5.0] - 2019-01-13

### Added

 - Added methods to easily run elements of an arbitrarily rooted model tree through a given block of code.


## [1.4.0] - 2018-11-14

### Added

 - Now compatible with Gherkin 6.x.


## [1.3.0] - 2017-10-19

### Added

 - Now compatible with Gherkin 5.x.


## [1.2.1] - 2017-04-25

### Added

 - Now officially compatible with Rake 12.x.


## [1.2.0] - 2016-11-23

### Added

 - The comments in a feature file are now a modeled element.


## [1.1.1] - 2016-10-28

### Fixed

 - Abstract instantiation of models when using a non-default dialect 
   now works correctly.


## [1.1.0] - 2016-10-28

### Added

 - Support added for non-English dialects. This gem should now be able to model 
   feature files using any dialect supported by the 'gherkin' gem.

 - Models for elements of Gherkin that have keywords (e.g. 'Feature', 'Scenario', 
   'Examples') now keep track of the keyword used by the element that they model.

### Fixed

 - Fixed a bug that was causing example models to output extra newline 
   characters under certain circumstances. 


## [1.0.4] - 2016-10-07

### Fixed

 - Fixed a bug that caused some models to include nil objects in their 
   children collection if they did not have the relevant child object.


## [1.0.3] - 2016-09-12

### Fixed

 - Fixed a gem dependency that was accidentally declared with '<=' instead of '<'.


## [1.0.2] - 2016-09-12

### Added

 - A more detailed gem description and summary have been added to the gemspec.

 - The gem now declares version limits on its dependencies.
 
 - Badges for the current status of the project have been added to the Readme.


## [1.0.1] - 2016-09-10

### Added

 - In the Readme file, added a link to the published documentation.


## [1.0.0] - 2016-09-08

### Added

 - Background models can now be compared to other models that have steps (i.e. 
   scenarios and outlines).

 - Added specific ancestor types for scenario, outline, and background models as 
   alternatives to the generic 'test' ancestor type.


### Changed

 -  A base model class has been added in order to simplify adding new element 
   models. Other classes and modules used for organizing common model behavior 
   have been created/removed/renamed.

 - All modeled elements of a Cucumber test suite are now modeled with actual 
   classes. Previously, some elements (such as tags or rows in an example table) 
   were modeled with simple strings.

 - Feature file models now only have a single feature model instead of a 
   collection of them (that would only ever have one item in it).

 - Rows in an example table and rows in a step table no longer use two different 
   classes for modeling.

 - All models for Gherkin elements now track the line number from which they 
   originate in a source file.

 - The source line of a model is now a mutable attribute instead of being read 
   only.

 - The file path of a feature file is now a mutable attribute instead of being 
   read only.

 - Standardized the initial values of the attributes of abstractly created 
   models so that they are consistent across model types.

 - Extra whitespace around parsed element descriptions is now trimmed away 
   before being stored in a model.
  
 - Adding rows to examples via hashes can now be done without regard to the 
   order of the keys in the hash. The correct order can be determined by the 
   model.

 - The saved parsing data that is generated by the 'gherkin' gem is no longer 
   duplicated for each model, resulting in significantly less memory usage.

 - Various methods have been renamed.


### Removed

 - Removed the backdoor used to pass around model data during the model creation 
   process. Model input can now only be text.

 - Simple counting methods have been removed. Ruby's collection methods are just 
   as easy to use directly when dealing with classes that contain collections 
   and the removal of these counting methods simplifies the codebase.

 - The 'World' module has been removed. The scope of this gem is to model files 
   written in Gherkin. Concepts like 'step definitions' and 'hooks' are better 
   left to libraries that include (possibly programming language specific) test 
   execution logic within their scope of concern.

 - Step models no longer have 'arguments' because they require the concept of 
   step definitions, which are no longer within the scope of this gem.

 - Removed deprecated behavior
     - Marked
         - Doc strings no longer use an array of strings to model their content
         - Tables no longer use nested arrays of strings to model their rows
         - Models that have descriptions no longer use an array of strings to 
           model their description
         - The convenient (read: awkward) #step_text has been removed.
     - Unmarked
         - Examples no longer use an array of hashes to model their rows


### Fixed

 - String output of models has been improved. More special characters in Gherkin 
   (e.g. vertical bars in rows) are appropriately escaped in the string output 
   of a model and several minor bugs related to using model string output as the 
   input text for new models have been fixed.


## [0.4.1] - 2016-05-12

### Added

 - Increased the flexibility of input when adding rows to an Example object. Non-
   string values can now be used as input and they will be converted into 
   strings. Original input objects are not modified.

 - Added some error checking around adding value rows to an Example object 
   without adding a parameter row as well.


## [0.4.0] - 2016-05-01

### Added

 - The path of a Directory object is now a changeable attribute instead of only 
   being populated if the instance was given a diretory to model.

### Fixed

 - Fixed a bug that occurred if a Directory object was asked for its 
   `#name` when it was created as 'abstract' instead of modeling an existing 
   directory.


## [0.3.0] - 2016-04-24

### Added

 - Support for version 4.x of the 'gherkin' gem added.

### Fixed

 - Fixed a bug that was preventing Example objects from being created 
   from text if that text had less Gherkin structure than normal.


## [0.2.0] - 2016-02-21

### Added

 - Better error feedback when parsing errors are encountered. It is now easier 
   to tell which file contained invalid Gherkin.


## [0.1.0] - 2016-02-10

### Added

 - Support for version 3.x of the 'gherkin' gem added.

### Fixed

 - The saved parsing data that is generated by the 'gherkin' gem is no 
   longer modified by the rest of the model creation process.


## [0.0.2] - 2015-11-22

### Fixed

 - Fixed a bug that was causing object comparison using #== to not 
   work when comparing some models to other types of objects.


## [0.0.1] - 2014-06-02

### Added

 - Initial release


[Unreleased]: https://github.com/enkessler/cuke_modeler/compare/v3.5.0...HEAD
[3.5.0]: https://github.com/enkessler/cuke_modeler/compare/v3.4.0...v3.5.0
[3.4.0]: https://github.com/enkessler/cuke_modeler/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/enkessler/cuke_modeler/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/enkessler/cuke_modeler/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/enkessler/cuke_modeler/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/enkessler/cuke_modeler/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/enkessler/cuke_modeler/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/enkessler/cuke_modeler/compare/v1.5.1...v2.0.0
[1.5.1]: https://github.com/enkessler/cuke_modeler/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/enkessler/cuke_modeler/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/enkessler/cuke_modeler/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/enkessler/cuke_modeler/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/enkessler/cuke_modeler/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/enkessler/cuke_modeler/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/enkessler/cuke_modeler/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/enkessler/cuke_modeler/compare/v1.0.4...v1.1.0
[1.0.4]: https://github.com/enkessler/cuke_modeler/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/enkessler/cuke_modeler/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/enkessler/cuke_modeler/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/enkessler/cuke_modeler/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/enkessler/cuke_modeler/compare/v0.4.1...v1.0.0
[0.4.1]: https://github.com/enkessler/cuke_modeler/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/enkessler/cuke_modeler/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/enkessler/cuke_modeler/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/enkessler/cuke_modeler/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/enkessler/cuke_modeler/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/enkessler/cuke_modeler/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/enkessler/cuke_modeler/compare/ce627fb591966c9ef19a9e69338b1282e9902a0d...v0.0.1
