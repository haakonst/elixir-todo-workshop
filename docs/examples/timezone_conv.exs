defmodule TimezoneConv do
  # Timex is a popular date/time library for Elixir. You'd usually want to display
  # timestamps in the user's local timezone while storing them in UTC in the DB for
  # simplicity and to avoid amiguities. So timestamps must be converted from UTC to
  # local time before displaying them. This can be done by a client side library
  # like moment.js or on the server side. However, for a server oriented framework
  # like Phoenix it might be natural to do this on the server. We therefore must obtain
  # the users's local time zone, and alas, the only way is to use the JavaScript
  # function (new Date()).getTimezoneOffset(). Also this returns the timezone
  # as the difference from UTC to local time in minutes as an integer. The Timex
  # function Timex.Timezone.convert which we'd use in Elixir to convert the timestamps,
  # accepts the timezone as the difference hours and minutes from local time to UTC
  # represented as a string of the form [-+]HH:mm. The following functions does the
  # timezone conversion.

  @doc """
  Convert timezone specified as the difference in minutes from UTC to local time
  to timezone specified as the difference in hours and minutes from local time to UTC
  in the format [-+]HH:mm (ISO 8601).
  """
  def timezone_minutes_to_iso(minutes) do
    # Support both string and integer parameters.
    # The cond do ... end is like a multi-branch if-else statement.
    minutes =
      cond do
        is_binary(minutes) ->
          case Integer.parse(minutes) do # Pattern matching on the result of the parsing function.
            {minutes, ""} -> minutes
            _ -> nil
          end
        is_integer(minutes) -> minutes
        true -> nil
      end

    # Debug output statement.
    IO.inspect(minutes, label: "Minutes")

    if minutes do
      hours =
        String.pad_leading(to_string(div(abs(minutes), 60)), 2, "0")

      # Function composition can also be done using "pipeline syntax".
      # The result of one function is passed as the first argument of the next function in the pipline.
      mins =
        minutes
        |> abs()
        |> rem(60)
        |> IO.inspect(label: "Minutes calc") # Debug output statements can also be inserted in the middle of a pipeline.
        |> to_string()
        |> String.pad_leading(2, "0")

      "#{minutes > 0 && "-" || "+"}#{hours}:#{mins}"
    end
  end
end

IO.puts("Timezone: " <> TimezoneConv.timezone_minutes_to_iso("-120")) # Yields "+02:00" (CEST)
