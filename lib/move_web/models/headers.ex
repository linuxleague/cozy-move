# I can't make set_locale works for me, but I've taken a valuable part:
# https://github.com/smeevil/set_locale/blob/master/lib/headers.ex
defmodule MoveWeb.Models.Headers do
  @moduledoc """
  This module provides some helpers for working with HTTP headers, like
  extracting a locale from the Accept-Language header.
  """

  @supported_locales Gettext.known_locales(MoveWeb.Gettext)
  @default_locale "en"

  def get_locale(conn) do
    get_locale_from_header(conn) || @default_locale
  end

  defp get_locale_from_header(conn) do
    conn
    |> extract_accept_language()
    |> Enum.find(nil, fn l -> Enum.member?(@supported_locales, l) end)
  end

  def extract_accept_language(conn) do
    case Plug.Conn.get_req_header(conn, "accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)
        |> Enum.reject(&is_nil/1)
        |> ensure_language_fallbacks()

      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures = Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

    quality =
      case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

    %{tag: captures["tag"], quality: quality}
  end

  defp ensure_language_fallbacks(tags) do
    Enum.flat_map(tags, fn tag ->
      [language | _] = String.split(tag, "-")
      if Enum.member?(tags, language), do: [tag], else: [tag, language]
    end)
  end
end
