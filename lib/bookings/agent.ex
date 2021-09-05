defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking

  def start_link(state \\ %{}) do
    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, &handle_save(&1, booking))

    {:ok, id}
  end

  def list_all do
    Agent.get(__MODULE__, &Map.values/1)
  end

  def get(uuid), do: Agent.get(__MODULE__, &handle_get(&1, uuid))

  defp handle_save(state, %Booking{id: id} = booking), do: Map.put(state, id, booking)

  defp handle_get(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
