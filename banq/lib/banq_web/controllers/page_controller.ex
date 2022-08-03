defmodule BanqWeb.PageController do
  use BanqWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
