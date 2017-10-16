defmodule HardSvm do
  @moduledoc false

  def f(x,y) do
    x - y
  end

  def get_class(x, y) do
    if f(x, y) > 0 do
      1
    else
      -1
    end
  end

  def generate_point(n) do
    0..(n-1)
    |> Enum.map(fn(_) ->
      {:rand.uniform(30), :rand.uniform(30)}
    end)
    |> Enum.map(fn({x,y}) ->
      %{point: {x, y}, class: get_class(x, y)}
    end)

  end

  def generate_zero(n) do
    0..(n-1)
    |> Enum.map(fn(_) ->
      0
    end)
  end

  def transpose(x) when is_list(hd(x)) do
    0..(x |> Enum.at(0) |> Enum.count)-1
    |> Enum.map(fn(i) ->
      x
      |> Enum.map(fn(row) ->
        row
        |> Enum.at(i)
      end)
    end)
  end

  def transpose(x) do
    x
  end

  # [[x,x,x],[x,x,x],[x,x,x]], [[y,y,y],[y,y,y],[y,y,y]]
  def dot(x, y) when is_list(hd(x)) and is_list(hd(y)) do
    x
    |> Enum.map(fn(xrow) ->
      y
      |> transpose
      |> Enum.map(fn(yrow) ->
        xrow
        |> Enum.zip(yrow)
        |> Enum.map(fn({xcol, ycol}) ->
          xcol*ycol
        end)
        |> Enum.sum
      end)
    end)
  end

  # [[x,x,x],[x,x,x],[x,x,x]], [y,y,y]
  def dot(x, y) when is_list(hd(x)) and is_list(y) do
    x
    |> Enum.map(fn(xrow) ->
      y
      |> transpose
      |> Enum.zip(xrow)
      |> Enum.map(fn({ycol,xcol}) ->
        xcol*ycol
      end)
      |> Enum.sum
    end)
  end

  # [x,x,x], [[y,y,y],[y,y,y],[y,y,y]]
  def dot(x, y) when is_list(x) and is_list(hd(y)) do
    y
    |> transpose
    |> Enum.map(fn(yrow) ->
      x
      |> Enum.zip(yrow)
      |> Enum.map(fn({xcol, ycol}) ->
        xcol*ycol
      end)
      |> Enum.sum
    end)
  end

  # x, [[y,y,y],[y,y,y],[y,y,y]]
  def dot(x, y) when not is_list(x) and is_list(hd(y)) do
    y
    |> Enum.map(fn(yrow) ->
      yrow
      |> Enum.map(&(&1*x))
    end)
  end

  # [x,x,x] [y,y,y]
  def dot(x,y) when is_list(x) and is_list(y) do
    x
    |> Enum.zip(y)
    |> Enum.map(fn({xcol, ycol}) ->
      xcol * ycol
    end)
    |> Enum.sum
  end

  # x, [y,y,y]
  def dot(x, y) when not is_list(x) and is_list(y) do
    y
    |> Enum.map(&(&1*x))
  end

  # x, y
  def dot(x, y) when not is_list(x) and not is_list(y) do
    x * y
  end

  def dot(_x,_y) do
    raise("dot(x,y) : Invalid value")
  end

  # [[x,x,x],[x,x,x],[x,x,x]], [[y,y,y],[y,y,y],[y,y,y]]
  def mul(x, y) when is_list(hd(x)) and is_list(hd(y)) do
    x
    |> Enum.zip(y)
    |> Enum.map(fn({xrow, yrow}) ->
      xrow
      |> Enum.zip(yrow)
      |> Enum.map(fn({xcol, ycol}) ->
        xcol*ycol
      end)
    end)
  end

  # [x,x,x], [[y,y,y],[y,y,y],[y,y,y]]
  def mul(x, y) when is_list(x) and is_list(hd(y)) do
    y
    |> Enum.map(fn(yrow) ->
      x
      |> Enum.zip(yrow)
      |> Enum.map(fn({xcol, ycol}) ->
        xcol*ycol
      end)
    end)
  end

  # x, [[y,y,y],[y,y,y],[y,y,y]]
  def mul(x, y) when not is_list(x) and is_list(hd(y)) do
    y
    |> Enum.map(fn(yrow) ->
      yrow
      |> Enum.map(&(&1*x))
    end)
  end

  # [x,x,x] [y,y,y]
  def mul(x,y) when is_list(x) and is_list(y) do
    x
    |> Enum.zip(y)
    |> Enum.map(fn({xcol, ycol}) ->
      xcol * ycol
    end)
  end

  # x, [y,y,y]
  def mul(x, y) when not is_list(x) and is_list(y) do
    y
    |> Enum.map(&(&1*x))
  end

  def mul(x, y) when not is_list(x) and not is_list(y) do
    x * y
  end

  def mul(_x,_y) do
    raise("mul(x,y) : Invalid value")
  end

  def plot_with_line(points, func) do
    gp_cmd = """
    plot "plot/pointsm.gp" using 1:2;
    replot "plot/pointsp.gp" using 1:2;
    replot #{func};
    pause -1
    """

    textm =
      points
      |> Enum.filter(&(&1[:class] == -1))
      |> Enum.map(fn(%{point: {x,y}}) ->
        "#{x} #{y}"
      end)
      |> Enum.join("\n")
    textp =
      points
      |> Enum.filter(&(&1[:class] == 1))
      |> Enum.map(fn(%{point: {x,y}}) ->
        "#{x} #{y}"
      end)
      |> Enum.join("\n")
    File.write!("./plot/pointsm.gp", textm)
    File.write!("./plot/pointsp.gp", textp)

    System.cmd("gnuplot", ["-e", gp_cmd])
end

  def to_point(train) when is_map(train)  do
    {x,y} = train
    |> Map.get(:point)
    [x,y]
  end

  def to_point(train) do
    train
    |> Enum.map(fn(%{point: {x, y}}) ->
      [x, y]
    end)
  end

  def to_class(train) when is_map(train) do
    train
    |> Map.get(:class)
  end

  def to_class(train) do
    train
    |> Enum.map(fn(%{class: c}) ->
      c
    end)
  end

  def add(xx,yy) do
    xx
    |> Enum.zip(yy)
    |> Enum.map(fn({x,y}) ->
      x+y
    end)
  end

  def gradient_descent(train, alpha, beta \\ 1.0, eta_al \\ 0.0001, eta_be \\ 0.1, itr \\ 1000)
  def gradient_descent(train, alpha, _, _, _, 0) do {train, alpha} end
  def gradient_descent(train, alpha, beta, eta_al, eta_be, itr) do
    x =
      train
      |> Enum.map(fn(t) ->
        t |> to_class()
        |> mul(t |> to_point())
        |> dot(
          alpha
          |> mul(train |> to_class())
          |> mul(train |> to_point() |> transpose())
        )
        |> Enum.sum
      end)
    y =
      train
      |> Enum.map(fn(t) ->
        beta
        |> mul(t |> to_class)
        |> mul(alpha |> dot(train |> to_class))
      end)
    alpha = 1 |> sub(x) |> sub(y) |> Enum.map(&(&1 * eta_al)) |> add(alpha)
    beta =
      alpha
      |> Enum.map(fn(_) ->
        eta_be
        |> mul(alpha |> dot(train |> to_class()))
        |> :math.pow(2)
        |> Kernel./(2)
      end)
      |> Enum.sum
    gradient_descent(train, alpha, beta, eta_al, eta_be, itr-1)
  end

  def sub(x, y) when not is_list(x) do
    y
    |> Enum.map(fn(yy) ->
      x - yy
    end)
  end

  def sub(x, y) do
    x
    |> Enum.zip(y)
    |> Enum.map(fn({xx,yy}) ->
      xx-yy
    end)
  end

  def mean(x) do
    x
    |> Enum.sum
    |> Kernel./(x |> Enum.count)
  end

  def main(_opts) do
    n = 30
    {train, alpha} =
      generate_point(n) |> gradient_descent(generate_zero(n))
    index =
      alpha
      |> Enum.map(&(if &1 > 0, do: 1, else: 0))
    w =
      alpha
      |> mul(train |> to_class())
      |> transpose
      |> dot(train |> to_point())
    b =
      index
      |> Enum.zip(
        train |> to_class
        |> Enum.zip(train |> to_point |> dot(w))
      )
      |> Enum.filter(fn({i, _}) ->
        i == 1
      end)
      |> Enum.map(fn({_, {c, p}}) ->
        c - p
      end)
      |> mean
      plot_with_line(train, "-(#{w |> Enum.at(0)}*x + #{b}) / #{w |> Enum.at(1)}")
  end
end
