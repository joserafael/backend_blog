# Use the official Elixir image as base
FROM elixir:1.18-alpine

# Install build dependencies
RUN apk add --no-cache build-base git nodejs npm mysql-client

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix.exs and mix.lock files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy the entire application
COPY . .

# Compile the application
RUN mix compile

# Expose port 4000
EXPOSE 4000

# Set default command
CMD ["mix", "phx.server"]
