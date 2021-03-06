alias Plugger.Web.Router

defmodule PluggerTest do
  @moduledoc false
  use ExUnit.Case
  use Plug.Test

  @opts Router.init([])

  test "greets the world" do
    assert Plugger.hello() == :world
  end

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"
  end

  test "returns some metrics" do
    # Create a test connection
    conn = conn(:get, "/metrics")

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200

    # Assert contains at least 'http_requests_total' metric
    assert String.contains?(conn.resp_body, "http_requests_total")
  end

  test "responds 404 to not found" do
    # Create a test connection
    conn = conn(:get, "/any")

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "start code does not crash" do
    {:error, {:already_started, _pid}} = Plugger.Application.start(:normal, [])
  end
end
