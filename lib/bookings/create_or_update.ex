defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    Booking.build(complete_date, local_origin, local_destination, user_id)
    |> handle_response()
  end

  def call(_), do: {:error, "Invalid parameters"}

  defp handle_response({:ok, booking}), do: BookingAgent.save(booking)
end
