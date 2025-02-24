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
1. Update `MOST_CURRENT_GHERKIN_VERSION` in `cuke_modeler_project_settings.rb` (so that test filters know what 
   Gherkin ranges to use)
2. Update the `cucumber-gherkin` runtime dependency in `cuke_modeler.gemspec` (so that the new version is allowed 
   to be included in the gem bundle by Bundler)
3. Update`gherkin_major_version_used` in the `Gemfile` to the new version (so that it is the one getting used 
   during development). Also update `gherkin_major_versions_without_cucumber_support` if the new version does not have 
   a version of `cucumber` that uses it (which is more often than not).
4. Run the [tests](#testing) and fix the failures until everything is green again. This will, at the very least, 
   require the creation of a new adapter for the new Gherkin version (see existing adapters).
5. In addition to making sure that the existing tests pass...
     - Update any tests that are specific to certain versions of Gherkin in order to make them run with the new version 
       as well (usually done automatically by Step 1) or create a new version of the test that reflects the behavior 
       of the added version (see any test that uses Gherkin ranges as an example).
     - If the grammar of Gherkin has changed, update any tests that would be impacted, such as those that use 'maximum' 
       and 'minimum' sets of Gherkin.
     - Update any models that need new behavior due to changes in the grammar (e.g. `Rule`s going from untagged models to 
       tagged models in Gherkin 18.x)
6. Create a testing gemfile (see `testing/gemfiles`) for the new Gherkin version
7. Add the new testing gemfile to the CI matrix in the GitHub workflow file


### Making a new release of the gem
1. Update the `VERSION` in the `version` file
2. Update the [CHANGELOG](https://github.com/enkessler/cuke_modeler/blob/master/CHANGELOG.md)
    - Document any changes that were not documented as they were made
    - Make a new section for the release and a new unreleased section
    - Make a new release header a link (see existing release links)
3. Make sure that the `cuke_modeler:prerelease_check` Rake task is passing
4. Build the gem and tag the commit that it was built from using the `build_and_tag` 
   Rake task or manually with `git tag vX.Y.Z` and `gem build cuke_modeler.gemspec`
5. Publish the gem to RubyGems with `gem push cuke_modeler-X.Y.Z.gem`
