# Anonymous recursive functions in Racket

## Context

Some languages, like PowerShell, have “anonymous recursive
functions”. That is, normally, a function needs to use a name to refer
to itself to recur. But “anonymous recursion” means the language has
some special mechanism by which the function can refer to itself
without having to explicitly introduce a name. In some contexts, this
is called an *anaphoric* reference.

## Code

Here we show how we can easily implement this feature in Racket. The
file [`anon-rec.rkt`](./anon-rec.rkt) implements a macro called
`lam/anon♻️`, short for "lambda with anonymous recursion".
This specifically binds the name `$MyInvocation`, to mimic the syntax
of PowerShell, though the `$` here does not mean anything special.

## Examples

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

## Utility

Jokes aside, why is this useful?

I've often had the experience that I'm writing
some helper function as a `lambda`, then half-way through realize it would be
nice if the function could recur. But on its own a `lambda` can't recur, because
it's *anonymous*, and recursion requires a name. So the traditional solution is
to rewrite the program: e.g., introduce a `letrec`, give a name, make this `lambda`
its right-hand side expression, then use tha name in the `lambda`s body.

All this
requires a fair bit of boring editing. It significantly increases the indentation
of the `lambda` body (which sometimes makes you want to add newlines). In addition,
the body of that `letrec` then usually just returns the name, which is a confusing
pattern the first few times you see it. And all this might be happening inside
the argument to a function. That's a lot of effort.

This avoids that problem. When you hit that point half-way through, you can leave
everything intact and just…recur. Of course, it would be nicer if you could give a
*meaningful* name to the recursive function. That way, also, you can choose which
function you want to recur on, not only the nearest enclosing named one.

## Don't Use This Macro!

If you're a Racket programmer, be aware there's already a good solution for this!
The 
[`rec` form](https://docs.racket-lang.org/mzlib/mzlib_etc.html#%28form._%28%28lib._mzlib%2Fetc..rkt%29._rec%29%29)
already does something very much like this. For instance, say you were half-way into
writing
```
(λ (n)
    (if (zero? n)
        1
        (* n •
```
whoops! Well, you can now *wrap* it in `rec`, choosing the name you'd like:
```
(rec fact
  (λ (n)
    (if (zero? n)
        1
        (* n (fact (sub1 n))))))
```
The virtues of this solution are:

- This still evaluates to a function, as the `lambda` itself would have—indeed, critically, the same function.
- You can leave the body of the `lambda` unchanged (as with `letrec`), making changes on the outside.
  (This is in contrast to turning the `lambda` into a `define`.)
- Your indentation increases only slightly.
- You get to pick a meaningful name.
- You get to retain all the [bells-and-whistles](https://docs.racket-lang.org/reference/lambda.html#%28form._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._lambda%29%29) of `lambda`; `rec` is orthogonal to that.

`rec` is also defined in [SRFI-31](https://srfi.schemers.org/srfi-31/srfi-31.html), in case
you're a vanilla Schemer.

## Credits

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
