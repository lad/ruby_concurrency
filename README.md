ruby_concurrency
================

MRI
---

Demonstration of problems in Ruby Concurrency

|            | MRI 1.8.7 |           MRI 1.9.3           | MRI 2.1.5 | MRI Head (Jan 2016) |
|------------|:---------:|:-----------------------------:|:---------:|:-------------------:|
| Deadlock   |    Yes    |              Yes              |    Yes    |          No         |
| Stavartion |    Yes    | Hard to say. Always deadlocks |    Yes    |         Yes         |


JRuby
-----

|            | JRuby 1.6.8 |                                JRuby 1.7.11                                |                                Jruby 1.7.19                                |                             JRuby 9.0.0.0.pre1                             |
|:----------:|:-----------:|:--------------------------------------------------------------------------:|:--------------------------------------------------------------------------:|:--------------------------------------------------------------------------:|
|  Deadlock  |     Yes     | No Deadlock or Starvation only because the Timeout exception is not raised | No Deadlock or Starvation only because the Timeout exception is not raised | No Deadlock or Starvation only because the Timeout exception is not raised |
| Starvation |     Yes     | No Deadlock or Starvation only because the Timeout exception is not raised | No Deadlock or Starvation only because the Timeout exception is not raised | No Deadlock or Starvation only because the Timeout exception is not raised |


Rubinius
--------

|             |  RBX 2.4.1 |                    RBX 2.5.2                    |
|:-----------:|:----------:|:-----------------------------------------------:|
|  Deadlock  :| VM Crashes | Yes. Though most times we see thread starvation |
| Starvation :| VM Crashes |                       Yes                       |
