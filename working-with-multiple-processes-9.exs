defmodule Worker do
  def work(scheduler) do
    send scheduler, { :ready, self }

    receive do
      { :perform, client, module, func_name, args } ->
        { time, result } = :timer.tc(module, func_name, args)
        send client, { :result, self, result, time }
        work(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end
end

defmodule Scheduler do
  def run(num_workers, module, func_name, args_queue) do
    (1..num_workers)
      |> Enum.map(fn(_) -> spawn(Worker, :work, [self]) end)
      |> distribute_work(module, func_name, args_queue, [])
  end

  def distribute_work(pids, module, func_name, args_queue, results) do
    receive do
      { :ready, pid } when length(args_queue) > 0 ->
        [ next_args | tail ] = args_queue
        send pid, { :perform, self, module, func_name, next_args }
        distribute_work(pids, module, func_name, tail, results)

      { :ready, pid } ->
        send pid, { :shutdown }
        if length(pids) > 1 do
          distribute_work(
            List.delete(pids, pid), module, func_name, args_queue, results
          )
        else
          indexes_by_pids = pids
            |> Enum.with_index
            |> Enum.into(HashDict.new, fn { pid, index } -> { index, pid } end)

          Enum.sort(results,
            fn { pid1, _, _ }, { pid2, _, _ } ->
              indexes_by_pids[pid1] < indexes_by_pids[pid2]
            end
          )
        end

      { :result, pid, result, time } ->
        distribute_work(
          pids, module, func_name, args_queue, [ {pid, result, time} | results ]
        )
    end
  end
end

defmodule CatChaser do
  def count_cats(dir_path) do
    file_arg_list = File.ls!(dir_path)
      |> Enum.filter(&!String.starts_with?(&1, "."))
      |> Enum.map(&(["#{dir_path}/#{&1}"]))
      |> Enum.filter(&!File.dir?(&1))

    workers_num = length(file_arg_list)

    { time, results } =
      :timer.tc(Scheduler, :run,
        [workers_num, CatChaser, :count_cats_in_file, file_arg_list]
      )

    :io.format "~.2f~n", [ time/1_000_000.0 ]
    results
      |> Enum.into([], fn {_, result, _ } -> result end)
      |> Enum.sum
  end

  def count_cats_in_file(file_path) do
    ~r/cat/
      |> Regex.scan(File.read!(file_path))
      |> length
  end
end

IO.inspect CatChaser.count_cats("/Users/max/dev/skeptick")
