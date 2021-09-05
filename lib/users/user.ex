defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(name, email, cpf, id \\ UUID.uuid4())

  def build(name, email, cpf, id) when is_bitstring(cpf) do
    {:ok,
     %__MODULE__{
       name: name,
       email: email,
       cpf: cpf,
       id: id
     }}
  end

  def build(_name, _email, cpf, _id) when is_number(cpf), do: {:error, "Cpf must be a String"}
  def build(_name, _email, _cpf, _id), do: {:error, "Invalid parameters"}
end
