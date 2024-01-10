defmodule MissionCommand.Chat do
  @moduledoc """
  Interact with a chat model.
  """

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  defp _model(), do: "TinyLlama/TinyLlama-1.1B-Chat-v1.0"

  @impl true
  def init(_init_arg) do
    {:ok, model_info} = Bumblebee.load_model({:hf, _model()})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, _model()})
    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, _model()})

    serving =
      Bumblebee.Text.generation(model_info, tokenizer, generation_config,
        compile: [batch_size: 10, sequence_length: 1028],
        stream: true,
        defn_options: [compiler: EXLA, lazy_transfers: :always]
      )

    children = [
      {Nx.Serving,
       serving: serving, name: MissionCommand.Chat.TinyLlama, batch_size: 10, batch_timeout: 100}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
