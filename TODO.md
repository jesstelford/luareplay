 [ ] Linear Interpolator
  * Should this be a module which holds a 'model' of the recordings it'll be
    interpolating?
  * And, it needs to be able to interpolate backwards and forwards (although,
    we could have a different interpolator function that is set during run
    time to switch between.
 [ ] What about run-length encoding to reduce memory footprint?
 [ ] Performance testing needed?
 [ ] Switch order of return values so recording is always captured, but not
   necessarily the 'next ID'
 [*] Unit Tests for Linear Interpolator
