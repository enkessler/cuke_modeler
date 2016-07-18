# CukeModeler


  The models provided by this gem are used to represent a test suite that is written in the Gherkin language.


The intention of this gem is to provide the ability to model a Cucumber test
suite. It provides a foundation upon which to build other useful tools for
interacting with a test suite that is written in Gherkin (and written with
Cucumber in particular).

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
common thing to model but smaller portions of a test suite can be modeled as well.

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

One could, if so inclined, use this method to dynamically edit or even create an
entire test suite.


### Other gems that are (or soon will be) powered by cuke_modeler

  * https://github.com/enkessler/cql
  * https://github.com/enkessler/cuketagger
  * https://github.com/enkessler/cuke_cataloger
  * https://github.com/grange-insurance/cuke_slicer

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
