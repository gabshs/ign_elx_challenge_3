defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(%{name: name, email: email, cpf: cpf}) do
    User.build(name, email, cpf)
    |> handle_save()
  end

  def call(_), do: {:error, "Invalid parameters"}

  defp handle_save({:ok, user}), do: UserAgent.save(user)

  defp handle_save({:error, reason}), do: {:error, reason}
end
