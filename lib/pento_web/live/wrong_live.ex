defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias Pento.Accounts

  def mount(_params, session, socket) do
    # user = Accounts.get_user_by_session_token(session["user_token"])
    random_int = Enum.random(0..10)
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess:",
        session_id: session["live_socket_id"],
        # current_user: user,
        time: time(),
        answer: random_int
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %> </h1>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number= {n}> <%= n %> </a>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}=data, socket) do
    answer = socket.assigns.answer
    guess = String.to_integer(guess)

    is_crrect = if guess == answer, do: true, else: false
    score =
      if is_crrect do
          score = socket.assigns.score + 1
      else
          score = socket.assigns.score - 1
      end

    message =
      if is_crrect do
        "Correct! Your score: #{score}"
      else
        "Your guess: #{guess}. Wrong! Guess aggin."
      end
    now_time = time()
    {:noreply, assign(socket, message: message, score: score, time: now_time)}
  end

  defp time() do
    DateTime.utc_now |> to_string
  end
end
