# ruby_concurrency
Demonstration of problems in Ruby Concurrency

|            | MRI 1.8.7 |           MRI 1.9.3           | MRI 2.1.5 | MRI Head (Jan 2016) |
|------------|:---------:|:-----------------------------:|:---------:|:-------------------:|
| Deadlock   |    Yes    |              Yes              |    Yes    |          No         |
| Stavartion |    Yes    | Hard to say. Always deadlocks |    Yes    |         Yes         |
