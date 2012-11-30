# lager_bench

Lager benchmarks

[![Build Status](https://secure.travis-ci.org/aleksandr-vin/lager_bench.png)](http://travis-ci.org/aleksandr-vin/lager_bench)

Benchmarking is performed using [bencharka](https://github.com/aleksandr-vin/bencharka). This project keeps only benchmark files and run scripts.


## Benchmarking 'sync' vs. 'async' mode of `lager:dispatch_log/8`

### References

* **Commit under benchmark**: [aleksandr-vin/lager commit de380c88](https://github.com/aleksandr-vin/lager/commit/de380c88): *"Change lager:dispatch_log/8 to async style"* (this commit is the initial one introducing the behaviour change, see the dependant lager branch for more).
* Benchmarks: [bench/bench_flood_sync_dispatch_log.erl](https://github.com/aleksandr-vin/lager_bench/blob/master/bench/bench_flood_sync_dispatch_log.erl) and [bench/bench_flood_async_dispatch_log.erl](https://github.com/aleksandr-vin/lager_bench/blob/master/bench/bench_flood_async_dispatch_log.erl).


### Brief description

Comparing of the 'sync' vs. 'async 'version of `lager:dispatch_log/8` shown that the 'sync' one is about **2 times** slower *([travis-ci](https://travis-ci.org/aleksandr-vin/lager_bench/jobs/3440273) shows 2 times, while local desktop shows 6.6 times)* but 'async' one finished logging only **3.6%** of the events till the end of the pure benchmarking process execution.


### Conclusion

Seems that there should be an option for the user/developer: which kind the lager should be.

Now there is an **app env** named `sync_dispatch_log` that allows to
choose the subject behaviour. Access to its value is cached into
process dictionary but it seems that a compile-time switch should be
provided too: it will remove the unnesassary checks.

### Results of the benchmark

Current benchmark session performs a 5-time repeat of each benchmark, which measures a 100000 iterations of the "load", see files in `bench` directory for details.

Benchmark was done by calling `make` with the result (saved from travis-ci [run](https://travis-ci.org/aleksandr-vin/lager_bench/jobs/3440273)):
```erlang
% Aggregated result is:
                        [{"./bench_flood_sync_dispatch_log.erl",
                          [{ratio,1.0},
                           {avg,{ms,4966.7024}},
                           {min,{ms,4807.441}},
                           {max,{ms,5197.108}}]},
                         {"./bench_flood_async_dispatch_log.erl",
                          [{ratio,1.0},
                           {avg,{ms,2157.9307999999996}},
                           {min,{ms,1863.411}},
                           {max,{ms,2534.717}}]}]
```

### Resulting log files

To find the difference in log files completeness, run the benchmark with `make` and check log files `sync-test.log` and `async-test.log` in `bench` directory.
