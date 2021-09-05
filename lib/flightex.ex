defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.CreateOrUpdate, as: BookingCreateOrUpdate
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.CreateOrUpdate, as: UserCreateOrUpdate

  def start_agents do
    BookingAgent.start_link()
    UserAgent.start_link()
  end

  defdelegate create_or_update_booking(params), to: BookingCreateOrUpdate, as: :call
  defdelegate get_booking(id), to: BookingAgent, as: :get
  defdelegate create_or_update_user(params), to: UserCreateOrUpdate, as: :call
  defdelegate get_user(cpf), to: UserAgent, as: :get
end
