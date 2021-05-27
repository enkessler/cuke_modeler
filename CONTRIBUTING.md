# Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an 
interactive prompt that will allow you to experiment. For environments that can't run shell scripts directly, 
`bundle install` and `ruby bin/console` are analogous commands for the above steps.


### Testing

`bundle exec rake cuke_modeler:test_everything` will run all of the tests for the project. To run just the RSpec tests 
or Cucumber tests specifically:
 - `bundle exec rake cuke_modeler:run_rspec_tests` or
   `bundle exec rspec --pattern "testing/rspec/spec/**/*_spec.rb"`
 - `bundle exec rake cuke_modeler:run_cucumber_tests` or
   `bundle exec cucumber`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enkessler/cuke_modeler.

1. Fork it
2. Create your feature branch
   `git checkout -b my-new-feature`
3. Commit your changes
   `git commit -am 'Add some feature'`
4. Push to the branch
   `git push origin my-new-feature`
5. Create new Pull Request

Be sure to update the `CHANGELOG` to reflect your changes if they affect the outward behavior of the gem.

### Adding a new model

Some guidelines when adding a new model
  * Inherit from the base model class. Having a common base class will make it easier for other tools to 
  interact with the models.
  * Be sure that the model's parsing data is not stored by its parent model or else the raw data from the 
  Gherkin gem will get duplicated, which could result in a lot of extra data usage for large projects.
  
### Supporting additional versions of Gherkin

In addition to making sure that the existing tests pass...
 - Update any tests that are specific to certain versions of Gherkin in order to make them run with the new version 
   as well (if appropriate) or create a new version of the test that reflects the behavior of the added version.
 - If the grammar of Gherkin has changed, update any tests that would be impacted, such as those that use 'maximum' 
   and 'minimum' sets of Gherkin.
 - Update any models that need new behavior due to changes in the grammar (e.g. `Rule`s going from untagged models to 
   tagged models in Gherkin 18.x)
