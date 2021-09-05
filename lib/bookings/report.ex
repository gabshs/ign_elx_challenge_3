defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    filename
    |> File.write(handle_write())
  end

  def generate_report(from_date, to_date) do
    File.write("report-filtered.csv", handle_filter(from_date, to_date))

    {:ok, "Report generated successfully"}
  end

  defp handle_write do
    BookingAgent.list_all()
    |> Enum.map(&handle_line/1)
  end

  defp handle_line(%Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id
       }) do
    "#{user_id}, #{local_origin}, #{local_destination}, #{complete_date}\n"
  end

  defp handle_filter(from_date, to_date) do
    BookingAgent.list_all()
    |> Enum.filter(fn %Booking{complete_date: date} ->
      NaiveDateTime.compare(date, from_date) != :lt and
        NaiveDateTime.compare(date, to_date) != :gt
    end)
    |> Enum.map(&handle_line/1)
  end
end
