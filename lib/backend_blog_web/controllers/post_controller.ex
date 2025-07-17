defmodule BackendBlogWeb.PostController do
  use BackendBlogWeb, :controller

  alias BackendBlog.Blog
  alias BackendBlog.Repo
  alias BackendBlog.Blog.Post

  action_fallback BackendBlogWeb.FallbackController

  def index(conn, params) do
    page = Blog.list_posts() |> Repo.paginate(params)
    render(conn, :index, page: page)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{post}")
      |> render(:show, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- Blog.get_post(id) do
      render(conn, :show, post: post)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, post} <- Blog.get_post(id),
         {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, post} <- Blog.get_post(id),
         {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
