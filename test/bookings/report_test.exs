defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900, Brasilia, Bananeiras, 2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when the booking is between dates filtered, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900, Brasilia, Bananeiras, 2001-05-07 12:00:00"
      Flightex.create_or_update_booking(params)
      Report.generate_report(~N[2001-05-06 12:00:00], ~N[2021-05-07 12:00:00])
      {:ok, file} = File.read("report-filtered.csv")

      assert file =~ content
    end

    test "when the booking is not between dates filtered, return empty content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = ""
      Flightex.create_or_update_booking(params)
      Report.generate_report(~N[2001-05-16 12:00:00], ~N[2021-05-07 12:00:00])
      {:ok, file} = File.read("report-filtered.csv")

      assert file == content
    end
  end
end
