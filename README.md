# Master Forest

This gem parses and reduces combinatory logic written in Lazy K syntax.

## Usage

<table>
  <caption>MasterForest::Term methods</caption>
  <tbody>
  <tr><td>initialize(string)</td>  <td>argument is a Lazy K string</td></tr>
  <tr><td>leaf?</td>               <td>Is it a single letter like `s`, `k`, or `i`?</td></tr>
  <tr><td>valid?</td>              <td>Is it syntactically valid?</td></tr>
  <tr><td>normal?</td>             <td>Is it in normal form? (i.e. not further reducible)</td></tr>
  <tr><td>to_s</td>                <td>Serialize back to Lazy K</td></tr>
  <tr><td>l</td>                   <td>Left applicand; nil if leaf</td></tr>
  <tr><td>r</td>                   <td>Right applicand; nil if leaf</td></tr>
  <tr><td>reduce</td>              <td>Return single β reduction of term or term itself</td></tr>
  <tr><td>fully_reduce(depth)</td> <td>Reduce depth times or until normal, default depth is ∞</td></tr>
  </tbody>
</table>

## Performance

This gem includes two implementations of the same functionality,
`MasterForest::Term` and `MasterForest::MemcacheTerm`. If you
run memcache then the latter will use it to memoize previous
reductions. This goes much faster. You can test the speed by running
`benchmark/run.rb`.
