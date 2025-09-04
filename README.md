# Anonymous recursive functions in Racket

Some languages, like PowerShell, have “anonymous recursive
functions”. That is, normally, a function needs to use a name to refer
to itself to recur. But “anonymous recursion” means the language has
some special mechanism by which the function can refer to itself
without having to explicitly introduce a name. In some contexts, this
is called *anaphora*.


Here we show how we can easily implement this feature in Racket. The
file [`anon-rec.rkt`](./anon-rec.rkt) implements a macro called
`lam/anon♻️`, short for "lambda with anonymous recursion".
This specifically binds the name `$MyInvocation`, to mimic the syntax
of PowerShell, though the `$` here does not mean anything special.

The file [`client.rkt`](./client.rkt) shows several uses of increasing
and varying complexity:

* `fact` shows a standard factorial definition.

* How can we confirm that `$MyInvocation` is really bound to the right
  invocation? So `lucas-or-fib` is essentially a glorified version of
  the Fibonacci function, but the same body (which recurs using
  `$MyInvocation`) can also be used for the Lucas sequence given
  different initial values. This shows that the recursive function is
  bound correctly.
  
* `grid` shows that the correct binding occurs even in nested
  settings.
  
* `range` is a peculiar way to write a standard range-generating
  function. It exists only to check that “varargs” works properly with
  `lam/anon♻️`.

(In case you're wondering, I added `lam/anon♻️` to the `lambda`-like keywords
list of DrRacket's Indenting configuration. That's why the layout is so nice.)

Credits:

* James Brundage, “MrPowerShell”,
  [showed me](https://bsky.app/profile/mrpowershell.com/post/3lxx3yk4l5k2t)
  the PowerShell
  [`$MyInvocation`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.5#myinvocation)
  on Bluesky.
  
* Ali M, `@deadmarshal` on `mastodon.social`,
  [pointed out](https://mastodon.social/@deadmarshal/115144121899754304)
  that Forth has a keyword named
  [`RECURSE`](https://forth-standard.org/standard/core/RECURSE)
  that does this.
