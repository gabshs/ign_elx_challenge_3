defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  def start_link(process \\ %{}) do
    Agent.start_link(fn -> process end, name: __MODULE__)
  end

  def save(%User{} = user), do: Agent.update(__MODULE__, &handle_save(&1, user))

  def get(cpf) do
    Agent.get(__MODULE__, &handle_get(&1, cpf))
  end

  defp handle_save(state, %User{cpf: cpf} = user), do: Map.put(state, cpf, user)

  defp handle_get(state, cpf) do
    case Map.get(state, cpf) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "User not found"}
    end
  end
end
