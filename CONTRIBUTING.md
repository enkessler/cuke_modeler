# Development

After checking out the repo, run `bundle install` to install dependencies.

### Testing

`bundle exec rake cuke_modeler:test_everything` will run all of the tests for the project.

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
  * Be sure that the model's parsing data is not stored by it's parent model or else the raw data from the 
  Gherkin gem will get duplicated, which could result in a lot of extra data usage for large projects.
  
