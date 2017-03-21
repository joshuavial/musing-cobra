defmodule MusingCobra do
  def hello do
    ExTwitter.search("elixir-lang", [count: 15])
    |> Enum.map( fn (tweet) -> tweet.text end ) 
    |> Enum.filter( fn (txt) -> txt =~ ~r/http/ end) 
    |> Enum.map(fn (txt) -> Regex.run(~r/http[^\s]*/, txt) end) 
    |> Enum.filter(fn (url) -> !(List.first(url) =~ ~r/…/) end)
    |> expand_links
  end

  def expand_links (array) do
    Enum.map(array, fn (url) ->  HTTPoison.get!(url, [], [follow_redirect: false]) end)
    |> Map.get(:headers)
    |> Enum.map(fn (header) -> find_redirect(header) end)
    |> Enum.filter(&(&1 != nil))
    |> IO.inspect
  end

  def find_redirect ({"location", y2}) do
    y2
  end

  def find_redirect ({_, y2}) do 
    nil
  end
end
