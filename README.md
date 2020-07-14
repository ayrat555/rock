# ROCK

ROCK: A Robust Clustering Algorithm for Categorical Attributes

The algorithm's description http://theory.stanford.edu/~sudipto/mypapers/categorical.pdf

## Installation

The easiest way to add Rock to your project is by [using Mix](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html).

Add `:rock` as a dependency to your project's `mix.exs`:

```elixir
defp deps do
  [
    {:rock, "~> 0.1.2"}
  ]
end
```

And run:

    $ mix deps.get

## Basic Usage

To clusterize points using the Rock algorithm you should use Rock.clusterize/4 with the arguments:

  * `points`, points that will be clusterized
  * `number_of_clusters`, the number of desired clusters.
  * `theta`, neighborhood parameter in the range [0,1). Default value is 0.5.
  * `similarity_function`, distance function to use. Jaccard Coefficient is used by default.

```elixir

  ## Examples

      points =
      [
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]},
        {"point3", ["1", "2", "5"]},
        {"point4", ["1", "3", "4"]},
        {"point5", ["1", "3", "5"]},
        {"point6", ["1", "4", "5"]},
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point9", ["2", "4", "5"]},
        {"point10", ["3", "4", "5"]},
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]},
        {"point13", ["1", "6", "7"]},
        {"point14", ["2", "6", "7"]}
      ]

      # Example 1

      Rock.clusterize(points, 5, 0.4)
      [
        [
          {"point4", ["1", "3", "4"]},
          {"point5", ["1", "3", "5"]},
          {"point6", ["1", "4", "5"]},
          {"point10", ["3", "4", "5"]},
          {"point7", ["2", "3", "4"]},
          {"point8", ["2", "3", "5"]}
        ],
        [
          {"point11", ["1", "2", "6"]},
          {"point12", ["1", "2", "7"]},
          {"point1", ["1", "2", "3"]},
          {"point2", ["1", "2", "4"]},
          {"point3", ["1", "2", "5"]}
        ],
        [
          {"point9", ["2", "4", "5"]}
        ],
        [
          {"point13", ["1", "6", "7"]}
        ],
        [
          {"point14", ["2", "6", "7"]}
        ]
      ]

      # Example 2 (with custom similarity function)

      similarity_function = fn(
          %Rock.Struct.Point{attributes: attributes1},
          %Rock.Struct.Point{attributes: attributes2}) ->

        count1 = Enum.count(attributes1)
        count2 = Enum.count(attributes2)

        if count1 >= count2, do: (count2 - 1) / count1, else: (count1 - 1) / count2
      end

      Rock.clusterize(points, 4, 0.5, similarity_function)
      [
        [
          {"point1", ["1", "2", "3"]},
          {"point2", ["1", "2", "4"]},
          {"point3", ["1", "2", "5"]},
          {"point4", ["1", "3", "4"]},
          {"point5", ["1", "3", "5"]},
          {"point6", ["1", "4", "5"]},
          {"point7", ["2", "3", "4"]},
          {"point8", ["2", "3", "5"]},
          {"point9", ["2", "4", "5"]},
          {"point10", ["3", "4", "5"]},
          {"point11", ["1", "2", "6"]}
        ],
        [
          {"point12", ["1", "2", "7"]}
        ],
        [
          {"point13", ["1", "6", "7"]}
        ],
        [
          {"point14", ["2", "6", "7"]}
        ]
      ]
```


## Contributing

1. [Fork it!](http://github.com/ayrat555/rock/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Ayrat Badykov (@ayrat555)

## License

Rock is released under the MIT License. See the LICENSE file for further details.
