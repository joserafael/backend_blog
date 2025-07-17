defmodule BackendBlog.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias BackendBlog.Repo
  alias BackendBlog.Blog.Post

  @doc """
  Returns an `Ecto.Query` for listing posts.
  """
  def list_posts do
    from(p in Post, order_by: [desc: p.inserted_at, desc: p.id])
  end

  @doc """
  Gets a single post, returns a tuple.

  Returns `{:ok, post}` if the post is found, otherwise `{:error, :not_found}`.
  """
  def get_post(id) do
    case Repo.get(Post, id) do
      nil -> {:error, :not_found}
      post -> {:ok, post}
    end
  end

  @doc """
  Creates a post.
  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.
  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.
  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.
  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
