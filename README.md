# CukeModeler

There comes a time in every programmer's adventures with Cucumber when they 
want to do Really Cool Stuff with their tests. This usually necessitates 
scanning all of their feature files and playing with the output. While the 
**[gherkin](https://github.com/cucumber/gherkin)** gem does a fine job of parsing feature files, reading or even manipulating 
the resulting Abstract Syntax Tree is not always fun. **cuke_modeler** comes to 
the rescue by providing a modeling layer that is easier to work with.
 
Whether you just want something that will let you easily inspect your test 
suite or you are looking for a foundation tool upon which to build something 
Really Neat, this gem has you covered.


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

For more information on the different models and how to use them, see the 
[documentation](http://www.relishapp.com/enkessler/CukeModeler/docs).


## Modeling other versions of Cucumber

Although this gem is written in Ruby and requires it to run, the modeling 
capabilities provided are for the feature file layer of a Cucumber test suite. 
As such, any feature file that is written in Gherkin can be modeled, even if 
that feature is ultimately run with SpecFlow (Cucumber for C#), Lettuce 
(Cucumber for Python), or some other flavor of Cucumber. 


### Other gems that are (or soon will be) powered by cuke_modeler

  * [cql](https://github.com/enkessler/cql)
  * [cuketagger](https://github.com/enkessler/cuketagger)
  * [cuke_cataloger](https://github.com/enkessler/cuke_cataloger)
  * [cuke_slicer](https://github.com/grange-insurance/cuke_slicer)


## Contributing

1. Fork it
2. Create your feature branch (off of the development branch)
   `git checkout -b my-new-feature`
3. Commit your changes
   `git commit -am 'Add some feature'`
4. Push to the branch
   `git push origin my-new-feature`
5. Create new Pull Request
