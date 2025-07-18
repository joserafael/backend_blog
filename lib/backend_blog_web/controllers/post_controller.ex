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
    current_user = Guardian.Plug.current_resource(conn)
    post_params = Map.put(post_params, "user_id", current_user.id)
    
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
    current_user = Guardian.Plug.current_resource(conn)
    
    with {:ok, post} <- Blog.get_post(id),
         true <- post.user_id == current_user.id,
         {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, :show, post: post)
    else
      false -> conn |> put_status(:forbidden) |> json(%{error: "You can only update your own posts"})
      error -> error
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    
    with {:ok, post} <- Blog.get_post(id),
         true <- post.user_id == current_user.id,
         {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    else
      false -> conn |> put_status(:forbidden) |> json(%{error: "You can only delete your own posts"})
      error -> error
    end
  end
end
