defmodule BackendBlog.Repo do
  use Ecto.Repo,
    otp_app: :backend_blog,
    adapter: Ecto.Adapters.MyXQL
end
