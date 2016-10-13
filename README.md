# dd-trace-rb

[![CircleCI](https://circleci.com/gh/DataDog/dd-trace-rb/tree/master.svg?style=svg&circle-token=b0bd5ef866ec7f7b018f48731bb495f2d1372cc1)](https://circleci.com/gh/DataDog/dd-trace-rb/tree/master)

## Testing

You can launch all tests using the following rake command:
```
  $ rake test                     # tracer tests
  $ appraisal rails-4 rake rails  # rails 4 integration tests
  $ appraisal rails-5 rake rails  # rails 5 integration tests
  $ appraisal rake rails          # tests for all rails versions
```

We also enforce the Ruby [community-driven style guide][1] through Rubocop. Simply launch:
```
  $ rake rubocop
```

[1]: https://github.com/bbatsov/ruby-style-guide