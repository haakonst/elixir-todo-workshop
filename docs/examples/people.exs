defmodule People do
  @people [
    %{fname: "Bob", lname: "Hansen"},
    %{fname: "Tom", lname: "Smith"},
    %{fname: "Alice", lname: "Johnson"},
    %{fname: "Peter", lname: "Smith"},
    %{fname: "Bob", lname: "Smith"}
  ]

  def list(filter) do
    @people
    |> Enum.filter(filter)
    |> Enum.map(fn %{fname: fname, lname: lname} -> "#{fname} #{lname}" end)
    |> Enum.sort()
  end
end

People.list(fn person -> match?(%{lname: "Smith"}, person) end)
|> IO.inspect(label: "People")
