Basic stuff:
[![Gem Version](https://badge.fury.io/rb/cuke_modeler.svg)](https://rubygems.org/gems/cuke_modeler)
[![Project License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/mit-license.php)
[![Downloads](https://img.shields.io/gem/dt/cuke_modeler.svg)](https://rubygems.org/gems/cuke_modeler)

User stuff:
[![Cucumber Docs](http://img.shields.io/badge/Documentation-Features-green.svg)](https://github.com/enkessler/cuke_modeler/tree/master/testing/cucumber/features)
[![Yard Docs](http://img.shields.io/badge/Documentation-API-blue.svg)](https://www.rubydoc.info/gems/cuke_modeler)

Developer stuff:
[![Build Status](https://github.com/enkessler/cuke_modeler/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/enkessler/cuke_modeler/actions/workflows/ci.yml?query=branch%3Amaster)
[![Coverage Status](https://coveralls.io/repos/github/enkessler/cuke_modeler/badge.svg?branch=master)](https://coveralls.io/github/enkessler/cuke_modeler?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/83986d8f7a918fed9707/maintainability)](https://codeclimate.com/github/enkessler/cuke_modeler/maintainability)

---

# CukeModeler

There comes a time in every programmer's adventures with Cucumber when they 
want to do Really Cool Stuff with their tests. This usually necessitates 
scanning all of their feature files and playing with the output. While the 
**[cucumber-gherkin](https://github.com/cucumber/gherkin)** gem ([previously](https://github.com/enkessler/cuke_modeler/blob/master/CHANGELOG.md#300---2020-06-08) just the `gherkin` gem) does a fine job of parsing feature files, reading or even manipulating 
the resulting Abstract Syntax Tree is not always fun. **cuke_modeler** comes to 
the rescue by providing a modeling layer that is easier to work with.
 
Whether you just want something that will let you easily inspect your test 
suite or you are looking for a foundation tool upon which to build something 
[Really Neat](#projects), this gem has you covered.


## Installation

Add this line to your application's Gemfile:

    gem 'cuke_modeler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuke_modeler

## Usage

First, load up the gem code.

    require 'cuke_modeler'

Next, choose what you want to model. Directories and feature files are the most
common thing to model but smaller portions of a test suite can be modeled as 
well.

    directory = CukeModeler::Directory.new('path/to/the/code_directory')
    file = CukeModeler::FeatureFile.new('path/to/the/feature_file')

    gherkin = "Scenario: some test\n* a step"
    test = CukeModeler::Scenario.new(gherkin)

The models can then be inspected for information.

    directory.path #=> 'path/to/the/code_directory'
    file.feature.name #=> 'the name of the feature'
    test.steps.count #=> 1


Things can be done in the other direction as well by starting with empty models
and setting their attributes afterward.

    step = CukeModeler::Step.new
    step.keyword = 'Given'
    step.text = 'some step'

    test = CukeModeler::Scenario.new
    test.steps = [step]

    test.to_s #=> "Scenario:\n  Given some step"

One could, if so inclined, use this method to dynamically edit or even create 
an entire test suite!

For more information on the different models (which more or less have the same relation 
to each other as described in the AST [here](https://github.com/cucumber/cucumber/tree/master/gherkin#ast)) and how to use them, see the 
[documentation](https://github.com/enkessler/cuke_modeler/tree/master/testing/cucumber/features).

## Modeling dialects other than English

The modeling functionality provided by this gem will work with any dialect that 
is supported by the **cucumber-gherkin** gem. For modeling at the feature level or higher, 
no additional effort is needed because the `# language` header at the top of a 
feature already indicates that a non-default dialect is being used.

    # language: en-au
    Pretty much: An 'Australian' feature
    
      Aww, look mate: An 'Australian' scenario
        * a step
 
  In order to model smaller portions of Gherkin, however, the parser will need 
  to be told what dialect is being used.

    # Setting the dialect to 'Australian'
    CukeModeler::Parsing.dialect = 'en-au'
    
    gherkin = "Awww, look mate: some test\n* a step"
    test = CukeModeler::Scenario.new(gherkin)


## Modeling other versions of Cucumber

Although this gem is written in Ruby and requires it to run, the modeling 
capabilities provided are for the feature file layer of a Cucumber test suite. 
As such, any feature file that is written in Gherkin can be modeled, even if 
that feature is ultimately run with SpecFlow (Cucumber for C#), Lettuce 
(Cucumber for Python), or some other flavor of Cucumber. 


### <a id="projects"></a>Other gems that are powered by **cuke_modeler**

  * [cql](https://github.com/enkessler/cql) - A convenient DSL for querying modeled Gherkin documents
  * [cuketagger](https://github.com/enkessler/cuketagger) - A tool for adding tags to feature files
  * [cuke_cataloger](https://github.com/enkessler/cuke_cataloger) - Easily add uniques IDs to every test case in a suite
  * [cuke_slicer](https://github.com/enkessler/cuke_slicer) - Break a test suite down into discrete test cases for easy parallel distribution
  * [cuke_linter](https://github.com/enkessler/cuke_linter) - Identify common code smells in your Gherkin


## Development and Contributing

See [CONTRIBUTING.md](https://github.com/enkessler/cuke_modeler/blob/master/CONTRIBUTING.md)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
